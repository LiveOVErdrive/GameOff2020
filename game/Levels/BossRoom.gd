extends Spatial

onready var ceiling = $Ceiling
onready var player = $Player
onready var boss = $Navigation/LichNur
onready var animationPlayer = $AnimationPlayer

const introDialogue = [
	"WIZARD NODROG: Congratulations PALADIN, you have made it into CASTLE BLOODMOON.",
	"WIZARD NODROG: Freeing LICH NUR for the chance to destroy him for good is a bold move",
	"LICH NUR: Almost as bold as tricking my oldest enemy to come free me.",
	"LICH NUR: Come, PALADIN, let us see which of us will have their MOONSHOT pay off!"
]

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
	boss.attack()
	# TODO REMOVE THE ABOVE AND TURN THE ANIMATION BACK ON
	state = DIALOGUE
	#animationPlayer.play("introDialogue")

func playIntroDialogue(i:int):
	player.playDialogue(introDialogue[i])

func clearDialogue():
	player.clearDialogue()

func freezePlayer():
	player.setFreezePlayer(true)

func unFreezePlayer():
	player.setFreezePlayer(false)
