extends KinematicBody

var player
var fireballResource = preload("res://game/projectiles/Fireball.tscn")

const PROJECTILE_START_DISTANCE = 1
const PROJECTILE_START_HEIGHT = 1.3
const FIRING_WIDTH = .2
const PROJECTILE_SPEED = 15
const TRANSFORM_DISTANCE = 20

enum {
	WIZARD,
	ATTACK,
	BLOCK,
	ADVANCE,
	RETREAT
}

var state = WIZARD

onready var animationPlayer = $AnimationPlayer

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
	
	
	# State Machine
	if state == WIZARD:
		return
	elif state == ATTACK:
		# TODO check if we are doing an attack animation first
		if !(animationPlayer.is_playing() and animationPlayer.current_animation == "doubleshot"):
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
	elif state == DEAD or state == HURT:
		pass

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
