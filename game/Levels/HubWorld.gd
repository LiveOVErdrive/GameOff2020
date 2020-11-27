extends Spatial

onready var player = $Player
onready var global = get_node("/root/Global")
onready var animationPlayer = $AnimationPlayer

const tutorialText = [
	"WIZARD NODROG: LICH NUR is imprisoned in CASTLE BLOODMOON, behind me",
	"WIZARD NODROG: You must recover the three pieces of the PALADIN CREST, and use them to enter the Castle.",
	"WIZARD NODROG: Now, you must be disoriented after being dead for so long.  Allow me to refresh you.",
	"WIZARD NODROG: Use W,A,S, and D to move, and the mouse to look around.",
	"WIZARD NODROG: Left-click to swing your sword.",
	"WIZARD NODROG: Right-click to kick.\nThis doesn't injure the UNDEAD, but it can interrupt their attacks and blocks.",
	"WIZARD NODROG: Press SPACE to open doors and interact with the environment.",
	"WIZARD NODROG: That is all.  Go now, and destroy LICH NUR."
]

var tutorialLine = 0

func _ready():
	player.fadeIn()
	if !global.tutorialDone:
		global.tutorialDone = true
		showNextSlide()

func showNextSlide():
	if tutorialLine < tutorialText.size():
		animationPlayer.play("tutorial")

func showSlide():
	player.playDialogue(tutorialText[tutorialLine])
	tutorialLine += 1
