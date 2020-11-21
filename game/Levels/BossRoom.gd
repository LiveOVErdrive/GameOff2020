extends Spatial

onready var ceiling = $Ceiling

func _ready():
	ceiling.visible = true

static func getTooltip():
	return "LABYRINTHINE CATACOMBS"
