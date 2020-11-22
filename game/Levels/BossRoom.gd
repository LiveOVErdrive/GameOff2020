extends Spatial

onready var ceiling = $Ceiling
onready var player = $Player
onready var boss = $Navigation/LichNur

enum {
	PREFIGHT,
	DIALOGUE,
	PHASEONE,
	WIN
}
var state = PREFIGHT

func _ready():
	ceiling.visible = true


func _on_EntranceArea_area_entered(area):
	if area.get_parent() != player or state != PREFIGHT:
		return
	introDialogue()

func introDialogue():
	state = DIALOGUE
	player.setFreezePlayer(true)
	pass
