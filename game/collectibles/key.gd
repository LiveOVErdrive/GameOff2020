extends Spatial

const POTION_HP = 25

var player
var level

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite3D

export(int) var keyNum setget setKeyNum

func setKeyNum(kn):
	keyNum = kn

func _ready():
	add_to_group("collectibles")
	animationPlayer.play("rotate")
	level = get_parent()
	sprite.frame = keyNum

func setPlayer(p):
	player = p

func _on_PickupArea_area_entered(area):
	var thing = area.get_parent()
	if thing != player:
		return
	if level.playerHasKey(keyNum):
		return
	level.acquireKey(keyNum)
	player.updateHud()
	queue_free()

