extends KinematicBody


var player

func _ready():
	add_to_group("enemies")

func setPlayer(p):
	player = p

func _physics_process(delta):
	if !player:
		return
	look_at(player.translation, Vector3(0,1,0))
