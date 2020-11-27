extends StaticBody

export var targetScene : String setget setTargetScene
export var pieceNumber : int setget setPieceNumber

onready var global = get_node("/root/Global")

onready var sprite = $Sprite3D

const tooltips = [
	"GHOULISH GRAVEYARD",
	"GHOULISH GRAVEYARD\ncomplete",
	"DUNGEON OF DOOM",
	"DUNGEON OF DOOM\ncomplete",
	"CURSED COLOSSEUM",
	"CURSED COLOSSEUM\ncomplete",	
]

var tooltip : String
var tooltipClosed : String

func setTargetScene(ts):
	targetScene = ts

func setPieceNumber(pn):
	pieceNumber = pn

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = pieceNumber * 2
	if havePiece():
		frame += 1
	sprite.frame = frame

func use():
	if !havePiece():
		get_tree().change_scene(targetScene)

func getTooltip():
	if havePiece():
		return tooltips[pieceNumber*2+1]
	else:
		return tooltips[pieceNumber*2]

func havePiece():
	return global.havePiece(pieceNumber)
