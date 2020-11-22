extends KinematicBody

var player
var fireballResource = preload("res://game/projectiles/Fireball.tscn")

const PROJECTILE_START_DISTANCE = 1
const PROJECTILE_START_HEIGHT = 1.3
const FIRING_WIDTH = .2
const PROJECTILE_SPEED = 15
const TRANSFORM_DISTANCE = 20
const CORNER_CUT_DIST = 1
const SPEED = 5
const ATTACK_RANGE = 20

enum {
	WIZARD,
	ATTACK,
	BLOCK,
	ADVANCE,
	RETREAT
}

var path = []
var currentPathNode = 0
var state = WIZARD

onready var global = get_node("/root/Global")
onready var animationPlayer = $AnimationPlayer
onready var raycast = $RayCast
onready var nav = get_parent()

func _ready():
	add_to_group("enemies")
	animationPlayer.play("wizard")

func setPlayer(p):
	player = p

func _physics_process(delta):
	if !player:
		return
	
	# Manual Billboard
	var playerPoint = player.translation
	playerPoint.y = translation.y
	look_at(playerPoint, Vector3(0,1,0))
	
	var distanceToPlayer = getDistanceToPlayer()
	
#	var unitVecToPlayer = getVectorToPlayer()
#	unitVecToPlayer.y = 0
#	unitVecToPlayer = unitVecToPlayer.normalized()
	raycast.cast_to = player.translation
	
	# State Machine
	if state == WIZARD:
		return
	elif state == ATTACK:
		# TODO check if we are doing an attack animation first
		if !(animationPlayer.is_playing() and animationPlayer.current_animation == "doubleshot"):
			if !canSeePlayer():
				print("advancing")
				state = ADVANCE
				return
			else:
				animationPlayer.play("doubleshot")
	elif state == ADVANCE:
		if canSeePlayer():
			print("attacking")
			state = ATTACK
			return
		else:
			if currentPathNode >= path.size():
				getPathToPlayer()
			var moveDirection = path[currentPathNode] - global_transform.origin
			if moveDirection.length() < CORNER_CUT_DIST:
				currentPathNode += 1
			else:
				move_and_slide(moveDirection.normalized() * SPEED)

func advance():
	state = ADVANCE

func attack():
	state = ATTACK

func canSeePlayer():
	var col = raycast.get_collider()
	print(col)
	return col == player

func transform():
	animationPlayer.play("transform")

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()

func shootOne(offsetFactor: float):
	var fireDirection = getVectorToPlayer()
	fireDirection.y = 0
	fireDirection = fireDirection.normalized()
	var arrow = fireballResource.instance()
	var sideDirection = Vector3(fireDirection.z, 0, fireDirection.x) * offsetFactor
	arrow.translation = translation + fireDirection * PROJECTILE_START_DISTANCE + sideDirection * FIRING_WIDTH
	arrow.translation.y = PROJECTILE_START_HEIGHT
	arrow.setPlayer(player)
	arrow.setVelocity(fireDirection * PROJECTILE_SPEED)
	arrow.setSource(self)
	get_parent().get_parent().add_child(arrow)
	
func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
