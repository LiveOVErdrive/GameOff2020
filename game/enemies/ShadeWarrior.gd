extends KinematicBody

const SPEED = 6
const MIN_DIST_TO_PLAYER = 0
const MED_DIST_TO_PLAYER = 1.5
const MAX_DIST_TO_PLAYER = 3
const VIEW_DISTANCE = 15
const CORNER_CUT_DIST = 1
const MAX_HEALTH = 3

onready var nav = get_parent()
onready var player
onready var animationPlayer = $AnimationPlayer
onready var collisionShape = $CollisionShape
onready var hurtboxShape = $Hitbox/CollisionShape

enum {
	IDLE,
	ADVANCE,
	RETREAT,
	ATTACK,
	DEAD,
	HURT
}

var path = []
var currentPathNode = 0
var state
var health = MAX_HEALTH

func _ready():
	add_to_group("enemies")
	state = IDLE
	collisionShape.disabled = false
	animationPlayer.play("idlemove")

func setPlayer(p):
	player = p
	
# Interface Stuffs

func kick(direction):
	damage(3)
func slash():
	damage(1)
func stab():
	damage(2)
	
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
		pass
	elif state == RETREAT:
		if distanceToPlayer > MED_DIST_TO_PLAYER:
			attack()
		else:
			var fleeDirection = getVectorToPlayer().normalized() * -1
			fleeDirection.y = 0 # just to make sure
			move_and_slide(fleeDirection * SPEED)
	elif state == ADVANCE:
		if distanceToPlayer < MED_DIST_TO_PLAYER:
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
	
# State Stuff

func advance():
	state = ADVANCE
	animationPlayer.play("idlemove")
	getPathToPlayer()

func attack():
	animationPlayer.play("idlemove")
	state = ATTACK

func retreat():
	animationPlayer.play("idlemove")
	state = RETREAT

func idle():
	animationPlayer.play("idlemove")
	state = IDLE

func hurt():
	animationPlayer.play("idlemove")
	state = HURT

func die():
	animationPlayer.play("die")
	hurtboxShape.disabled = true
	state = DEAD

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
