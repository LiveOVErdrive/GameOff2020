extends KinematicBody


enum {
	BACK,
	QUARTERBACK,
	SIDE,
	QUARTERFRONT,
	FRONT
}

var velocity = Vector3()

onready var sprite = $Sprite3D
onready var raycast = $RayCast
var player

func setVelocity(v):
	velocity = v

func _ready():
	add_to_group("enemies")

	look_at(velocity, Vector3(0,1,0))

func setPlayer(p):
	player = p 

func _physics_process(delta):
	if !player:
		return

	move_and_slide(velocity)
	
	var col = raycast.get_collider()
	if col:
		if col.has_method("arrowHit"):
			col.arrowHit()
		queue_free() #delete self

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

