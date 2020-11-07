extends KinematicBody


enum {
	BACK,
	QUARTERBACK,
	SIDE,
	QUARTERFRONT,
	FRONT
}

const SPEED = 10

onready var sprite = $Sprite3D
var player

func _ready():
	add_to_group("enemies")

func setPlayer(p):
	print("set player")
	player = p


func _physics_process(delta):
	if !player:
		return
#	var col = move_and_collide(velocity * delta)
#	if col:
#		if col.has_method("arrowHit"):
#			col.arrowHit()
#		queue_free() #delete self

	var vecToPlayer = player.translation - translation
	var angleToPlayer = rotation.angle_to(vecToPlayer)
	if angleToPlayer >= 0 and angleToPlayer < 22.5:
		sprite.frame = FRONT
	
		
