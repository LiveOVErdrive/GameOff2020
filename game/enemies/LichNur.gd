extends KinematicBody


var player

func _ready():
	add_to_group("enemies")

func setPlayer(p):
	player = p

func _physics_process(delta):
	if !player:
		return
	var playerPoint = player.translation
	playerPoint.y = translation.y
	look_at(playerPoint, Vector3(0,1,0))
