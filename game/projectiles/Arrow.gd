extends KinematicBody

const DAMAGE = 10

enum {
	BACK,
	QUARTERBACK,
	SIDE,
	QUARTERFRONT,
	FRONT
}

var velocity = Vector3()

onready var sprite = $Sprite3D
var player
var source

func setSource(s):
	source = s

func setVelocity(v):
	velocity = v

func _ready():
	add_to_group("projectiles")
	look_at(velocity, Vector3(0,1,0))

func setPlayer(p):
	player = p 

func _physics_process(delta):
	if !player:
		return

	var col = move_and_collide(velocity * delta)
	if col:
		doHit(col.collider)

	# 3d 2d sprite stuff
	# TODO make a generic object to handle this elsewhere too?

	var vecToPlayer = player.translation - translation
	vecToPlayer.y = 0
	var vec2DToPlayer = Vector2(vecToPlayer.x, vecToPlayer.z)
	var velocity2D = Vector2(velocity.x, velocity.z)
	var angleToPlayer = velocity2D.angle_to(vec2DToPlayer)
	if angleToPlayer < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	angleToPlayer = abs(angleToPlayer)
	if angleToPlayer < 2*PI/16:
		sprite.frame = FRONT
	elif angleToPlayer < 2*PI*3/16:
		sprite.frame = QUARTERFRONT
	elif angleToPlayer < 2*PI*5/16:
		sprite.frame = SIDE
	elif angleToPlayer < 2*PI*7/16:
		sprite.frame = QUARTERBACK
	else:
		sprite.frame = BACK

func doHit(target):
	if target == source or target.is_in_group("enemies"):
		return
	if target.has_method("damage"):
		target.damage(DAMAGE)
	queue_free() #delete self

