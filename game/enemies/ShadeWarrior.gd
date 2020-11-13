extends KinematicBody

const SPEED = 6
const BLOCK_SPEED = 3
const TARGET_ATTACK_RANGE = 2
const MAX_ATTACK_RANGE = 3
const BLOCK_RANGE = 5
const VIEW_DISTANCE = 15
const CORNER_CUT_DIST = 1
const MAX_HEALTH = 10
const KICK_STRENGTH = 10
const KICK_DECCEL = 10
const DAMAGE = 10

onready var nav = get_parent()
onready var player
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape
onready var hurtboxShape = $Hurtbox/CollisionShape
onready var raycast = $RayCast

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

func _ready():
	add_to_group("enemies")
	add_to_group("blockers")
	state = IDLE
	collisionShape.disabled = false
	animationPlayer.play("idlemove")

func setPlayer(p):
	player = p
	
# Interface Stuffs

func kick(direction):
	kickDirection = direction
	kickSpeed = KICK_STRENGTH
	animationPlayer.play("hurt")
	state = KICKED
func slash():
	if blocking:
		riposte()
		# TODO return somtehing to make the player staggered for a second
	else:
		damage(5)
func stab():
	if blocking:
		riposte()
	else:
		damage(2)

func riposte():
	animationPlayer.play("riposte")
	pass
	
func damage(d):
	health -= d
	if health <= 0:
		die()
		animationPlayer.play("die")
	else:
		hurt()
		animationPlayer.play("hurt")

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
				if blocking:
					print("was blocking now attacking")
					animationPlayer.play("attack")
				else:
					animationPlayer.play("startBlock")
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
			if distanceToPlayer < BLOCK_RANGE:
				if animationPlayer.current_animation == "idlemove":
					animationPlayer.play("startBlock")
				elif !animationPlayer.is_playing():
					# keep playing holdblock
					animationPlayer.play("holdblock")
			elif blocking:
				animationPlayer.play("endBlock")
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

func setBlock(b: bool):
	blocking = b

func tryToHitPlayer(): 
	var target = raycast.get_collider()
	if target and target.has_method("damage"):
		target.damage(DAMAGE)

# State Stuff

func advance():
	state = ADVANCE
	animationPlayer.play("idlemove")
	getPathToPlayer()

func attack():
	animationPlayer.play("attack")
	state = ATTACK

func idle():
	animationPlayer.play("idlemove")
	state = IDLE

func hurt():
	animationPlayer.play("hurt")
	state = HURT

func die():
	animationPlayer.play("die")
	hurtboxShape.disabled = true
	state = DEAD

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
