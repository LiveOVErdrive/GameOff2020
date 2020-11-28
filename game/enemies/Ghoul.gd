extends KinematicBody

const SPEED = 4
const TARGET_ATTACK_RANGE = 2
const MAX_ATTACK_RANGE = 3
const VIEW_DISTANCE = 15
const CORNER_CUT_DIST = 1
const MAX_HEALTH = 10
const KICK_STRENGTH = 10
const KICK_DECCEL = 10
const DAMAGE = 3

onready var nav = get_parent()
onready var player
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape
onready var hurtboxShape = $Hurtbox/CollisionShape
onready var raycast = $RayCast
onready var particles = $Particles

enum {
	IDLE,
	ADVANCE,
	ATTACK,
	DEAD,
	KICKED,
	HURT
}

# AI:
# Advances to attack range
# Attacks
# Blocks in between attacks
# Ripostes if he blocks the player
# gets staggered if kicked

var path = []
var currentPathNode = 0
var state
var health = MAX_HEALTH
var kickDirection = Vector3()
var kickSpeed = 0
var blocking = false

onready var global = get_node("/root/Global")

func _ready():
	add_to_group("enemies")
	idle()
	collisionShape.disabled = false
	particles.visible = global.particlesEnabled

func setPlayer(p):
	player = p
	
# Interface Stuffs

func kick(direction):
	kickDirection = direction
	kickSpeed = KICK_STRENGTH
	animationPlayer.play("kicked")
	state = KICKED
	
func slash():
	damage(5)

func stab():
	damage(2)
	
func damage(d):
	health -= d
	if health <= 0:
		die()
	else:
		hurt()

# runloop

func _physics_process(delta):
	if !player:
		return
	
	look_at(player.translation, Vector3(0,1,0))

	var distanceToPlayer = getDistanceToPlayer()

	if state == IDLE:
		if distanceToPlayer < VIEW_DISTANCE:
			advance()
	elif state == ATTACK:
		if animationPlayer.is_playing():
			pass
		else:
			if distanceToPlayer > MAX_ATTACK_RANGE:
				advance()
			else:
				animationPlayer.play("attack")
	elif state == KICKED:
		kickSpeed = lerp(kickSpeed, 0, KICK_DECCEL * delta)
		if kickSpeed == 0:
			idle()
		else:
			move_and_slide(kickDirection * kickSpeed)
	elif state == ADVANCE:
		if distanceToPlayer < TARGET_ATTACK_RANGE:
			attack()
		else:
			if currentPathNode >= path.size():
				getPathToPlayer()
			var moveDirection = path[currentPathNode] - global_transform.origin
			if moveDirection.length() < CORNER_CUT_DIST:
				currentPathNode += 1
			else:
				move_and_slide(moveDirection.normalized() * SPEED)
	elif state == DEAD or state == HURT:
		pass

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()

func tryToHitPlayer(): 
	var target = raycast.get_collider()
	if target and target.has_method("damage"):
		target.damage(DAMAGE)

# State Stuff

func advance():
	state = ADVANCE
	animationPlayer.play("walk")
	getPathToPlayer()

func attack():
	animationPlayer.play("attack")
	state = ATTACK

func idle():
	animationPlayer.play("idle")
	state = IDLE

func hurt():
	animationPlayer.play("hurt")
	state = HURT

func die():
	animationPlayer.play("die")
	hurtboxShape.queue_free()
	collisionShape.queue_free()
	state = DEAD

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
