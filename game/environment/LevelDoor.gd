extends StaticBody

export var targetScene : String setget setTargetScene
export var tooltip : String setget setTooltip
export var tooltipClosed : String setget setTooltipClosed
export var pieceNumber : int setget setPieceNumber

onready var global = get_node("/root/Global")

func setTargetScene(ts):
	targetScene = ts

func setTooltip(tt):
	tooltip = tt

func setTooltipClosed(tt):
	tooltipClosed = tt

func setPieceNumber(pn):
	pieceNumber = pn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func use():
	if global.havePiece(pieceNumber):
		get_tree().change_scene(targetScene)

func getTooltip():
	return tooltip
