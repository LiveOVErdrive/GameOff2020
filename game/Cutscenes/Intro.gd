extends Node2D


onready var animationPlayer = $AnimationPlayer
onready var text = $Control/Sprite/Text
onready var space = $Control/Sprite/Spacebar

func _ready():
	text.text = slideTexts[frame]
	animationPlayer.play("DisplayText")
	space.visible = false

var allowSkip = false
var frame = 0

const slideTexts = [
	"A thousand years ago, the powerful LICH NUR, ravaged the world with his army of the living dead.",
	"But NUR was defeated by the mighty PALADIN. who imprisoned him in CASTLE BLOODMOON, cursed to exist only during the red light of a LUNAR ECLIPSE.",
	"The Earth prospered! But as the centuries passed, and the story fell to legend, LICH NUR's power grew from within his purgatory.",
	"Soon NUR was powerful enough, even from his exile, to raise his armies of the dead every BLOODMOON, and terrorize the people of Earth",
	"This BLOODMOON TERROR has become unbearable, and the people have turned to me, WIZARD NODROG, to raise the PALADIN from the dead to destroy LICH NUR for good",
	"And that, dear PALADIN, is how you come to be alive again, after one thousand years.  Will you save us again, in our hour of need?"
]

func _physics_process(delta):
	# System
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	if allowSkip and Input.is_action_just_pressed("ui_accept"):
		space.visible = false
		allowSkip = false
		frame += 1
		if frame >= slideTexts.size():
			get_tree().change_scene("res://game/Levels/HubWorld.tscn")
			return
		text.text = slideTexts[frame]
		animationPlayer.play("DisplayText")

func waitForPlayer():
	space.visible = true
	allowSkip = true
	animationPlayer.play("spacebar")
