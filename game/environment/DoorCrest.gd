extends Spatial

onready var global = get_node("/root/Global")

onready var crest1 = $Sprite3D
onready var crest2 = $Sprite3D2
onready var crest3 = $Sprite3D3
onready var light = $OmniLight


# Called when the node enters the scene tree for the first time.
func _ready():
	updateVis()
	pass

func _process(delta):
	updateVis()
	pass

func updateVis():
	crest1.visible = global.havePiece(0)
	crest2.visible = global.havePiece(1)
	crest3.visible = global.havePiece(2)
	light.visible = crest1.visible or crest2.visible or crest3.visible
