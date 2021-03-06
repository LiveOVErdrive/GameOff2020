extends Spatial

onready var global = get_node("/root/Global")

export var pieceNumber = 0 setget setPieceNumber

var player
var level


onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite3D
onready var particles = $Particles

func setPieceNumber(p):
	pieceNumber = p

func _ready():
	if global.havePiece(pieceNumber):
		queue_free()
	add_to_group("collectibles")
	animationPlayer.play("rotate")
	sprite.frame = pieceNumber + 1
	level = get_parent()
	particles.visible = global.particlesEnabled

func setPlayer(p):
	player = p

func _on_PickupArea_area_entered(area):
	var thing = area.get_parent()
	if thing != player:
		return
	global.getPiece(pieceNumber)
	player.updateHud()
	player.teleportHome()
	queue_free()

