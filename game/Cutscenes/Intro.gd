extends Node2D


onready var animationPlayer = $AnimationPlayer
onready var text = $Control/Sprite/Text
onready var space = $Control/Sprite/Spacebar
onready var sprite = $Control/Sprite

var allowSkip = false
var frame = 0

func _ready():
	text.text = slideTexts[frame]
	animationPlayer.play("DisplayText")
	space.visible = false
	frame = 0
	sprite.frame = frame


const slideTexts = [
	"One thousand years ago, the powerful LICH NUR, ravaged the world with his ARMIES OF THE DEAD.",
	"But a mighty PALADIN defeated NUR, and imprisoned him in CASTLE BLOODMOON, cursed to exist only during the red light of a LUNAR ECLIPSE.",
	"The Earth prospered! But as the centuries passed, LICH NUR's power grew from within his purgatory.",
	"Soon NUR was powerful enough to raise his ARMIES OF THE DEAD to terrorize the world of the living on every BLOODMOON.",
	"The ARMIES OF THE LIVING joined together every BLOODMOON to beat back the ARMIES OF THE DEAD, but this was not a war the living could win.",
	"They needed a MOONSHOT SOLUTION; a crazy plan to end this BLOODMOON TERROR once and for all.",
	"So they turned to me, WIZARD NODROG, to raise the PALADIN from the dead, that he might reopen CASTLE BLOODMOON, and destroy the LICH NUR forever.",
	# picture of the paladin facing forward holding his sword wtih a badass gritted teeth look like dredd. ready to kick skeleton ass.
	"And that, PALADIN, is how you come to be alive again, on this night of the BLOODMOON.  Will you help us?  Will you end this BLOODMOON TERROR?"
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
		sprite.frame = frame
		animationPlayer.play("DisplayText")

func waitForPlayer():
	space.visible = true
	allowSkip = true
	animationPlayer.play("spacebar")
