extends KinematicBody


var player
var fireballResource = preload("res://game/projectiles/Fireball.tscn")

const PROJECTILE_START_DISTANCE = 1
const PROJECTILE_START_HEIGHT = 1.3
const FIRING_WIDTH = .2
const PROJECTILE_SPEED = 15

onready var animationPlayer = $AnimationPlayer

func _ready():
	add_to_group("enemies")
	animationPlayer.play("doubleshot")

func setPlayer(p):
	player = p

func _physics_process(delta):
	if !player:
		return
	var playerPoint = player.translation
	playerPoint.y = translation.y
	look_at(playerPoint, Vector3(0,1,0))

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
