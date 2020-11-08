extends KinematicBody

const SPEED = 5
const MIN_DIST_TO_PLAYER = 4
const MED_DIST_TO_PLAYER = 8
const MAX_DIST_TO_PLAYER = 12
const VIEW_DISTANCE = 20
const CORNER_CUT_DIST = 1
const ARROW_SPEED = 12
const ARROW_START_DISTANCE = 1
const ARROW_HEIGHT = 1.1

const arrowResource = preload("res://game/projectiles/Arrow.tscn")

onready var nav = get_parent()
onready var player
onready var animationPlayer = $AnimationPlayer
onready var arrowSpawnPoint = $ArrowSpawnPoint

enum {
	IDLE,
	ADVANCE,
	RETREAT,
	ATTACK
}

var path = []
var currentPathNode = 0
var state

func _ready():
	add_to_group("enemies")
	state = IDLE

func setPlayer(p):
	player = p

func _physics_process(delta):
	if !player:
		return

	var distanceToPlayer = getDistanceToPlayer()

	if state == IDLE:
		if distanceToPlayer < VIEW_DISTANCE:
			advance()
	elif state == ATTACK:
		# TODO check if we are doing an attack animation first
		if !(animationPlayer.is_playing() and animationPlayer.current_animation == "shoot"):
			if distanceToPlayer < MIN_DIST_TO_PLAYER:
				retreat()
			elif distanceToPlayer > MAX_DIST_TO_PLAYER:
				advance()
			else:
				animationPlayer.play("shoot")
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

func releaseArrow():
	var fireDirection = getVectorToPlayer()
	fireDirection.y = 0
	fireDirection = fireDirection.normalized()
	var arrow = arrowResource.instance()
	arrow.translation = translation + fireDirection * ARROW_START_DISTANCE
	arrow.translation.y = ARROW_HEIGHT
	arrow.setPlayer(player)
	arrow.setVelocity(fireDirection * ARROW_SPEED)
	get_parent().get_parent().add_child(arrow)

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()
	
# State Stuff

func advance():
	state = ADVANCE
	animationPlayer.play("walkdown")
	getPathToPlayer()

func attack():
	animationPlayer.play("idle")
	state = ATTACK

func retreat():
	animationPlayer.play("walkdown")
	state = RETREAT

func idle():
	animationPlayer.play("idle")
	state = IDLE

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
