extends KinematicBody

var player
var fireballResource = preload("res://game/projectiles/Fireball.tscn")

const PROJECTILE_START_DISTANCE = 1
const PROJECTILE_START_HEIGHT = 1.3
const FIRING_WIDTH = .2
const PROJECTILE_SPEED = 20
const CORNER_CUT_DIST = 1
const SPEED = 5
const ATTACK_RANGE = 20
const CONSECUTIVE_PROJECTILES = 3
const BLOCK_CYCLES_BEFORE_BURST = 3
const BURST_PROJECTILES = 20

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
var repeatCounter = 0

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
		if !animationPlayer.is_playing():
			if repeatCounter > 0:
				animationPlayer.play("doubleshot")
				repeatCounter -= 1
			else:
				block()

	elif state == BLOCK:
		if !animationPlayer.is_playing():
			if repeatCounter > 0:
				animationPlayer.play("holdblock")
				repeatCounter -= 1
			else:
				animationPlayer.play("burst")
				
	elif state == ADVANCE:
		if canSeePlayer():
			attack()
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
	getPathToPlayer()
	animationPlayer.play("idle")

func attack():
	repeatCounter = CONSECUTIVE_PROJECTILES - 1
	state = ATTACK
	animationPlayer.play("doubleshot")

func block():
	repeatCounter = BLOCK_CYCLES_BEFORE_BURST
	state = BLOCK
	animationPlayer.play("startblock")

func canSeePlayer():
	var col = raycast.get_collider()
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

func burst():
	var degreeDifference = PI*2 / BURST_PROJECTILES
	var launchPoint = Vector3(0,0,-1)
	for n in range(BURST_PROJECTILES):
		# TODO create the projectiles at the different rotations
		launchPoint = launchPoint.rotated(Vector3(0,1,0), degreeDifference)
		var arrow = fireballResource.instance()
		arrow.translation = translation + launchPoint * PROJECTILE_START_DISTANCE
		arrow.translation.y = PROJECTILE_START_HEIGHT
		arrow.setPlayer(player)
		arrow.setVelocity(launchPoint * PROJECTILE_SPEED)
		arrow.setSource(self)
		get_parent().get_parent().add_child(arrow)
	advance()
		
