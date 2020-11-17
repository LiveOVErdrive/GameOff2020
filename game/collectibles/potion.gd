extends Spatial

onready var global = get_node("/root/Global")

const POTION_HP = 25

var player


onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite3D

func _ready():
	add_to_group("collectibles")
	animationPlayer.play("rotate")

func setPlayer(p):
	player = p

func _on_PickupArea_area_entered(area):
	var thing = area.get_parent()
	if thing != player:
		return
	if global.playerHealth >= global.MAX_HP:
		return
	global.setPlayerHealth(global.playerHealth + POTION_HP)
	player.updateHud()
	queue_free()

