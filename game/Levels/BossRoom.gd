extends Spatial

onready var ceiling = $Ceiling
onready var player = $Player
onready var boss = $Navigation/LichNur
onready var animationPlayer = $AnimationPlayer
onready var music = $AudioStreamPlayer

onready var global = get_node("/root/Global")

const introDialogue = [
	"WIZARD NODROG: Congratulations, PALADIN, you have made it into CASTLE BLOODMOON.",
	"WIZARD NODROG: Oh, you are wondering why I am here, and not the LICH NUR?",
	"LICH NUR: I AM the LICH NUR!",
	"LICH NUR: Come, PALADIN, let us finish what we started, one thousand years ago!"
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
	#boss.attack()
	# TODO REMOVE THE ABOVE AND TURN THE ANIMATION BACK ON
	state = DIALOGUE
	animationPlayer.play("introDialogue")

func playIntroDialogue(i:int):
	player.playDialogue(introDialogue[i])

func clearDialogue():
	player.clearDialogue()

func freezePlayer():
	player.setFreezePlayer(true)

func unFreezePlayer():
	player.setFreezePlayer(false)

func playmusic():
	music.playing=true
