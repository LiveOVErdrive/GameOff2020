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
	"One thousand years ago, the powerful LICH NUR ravaged the world with his ARMIES OF THE DEAD.",
	"But the mighty PALADIN defeated him, and banished him to CASTLE BLOODMOON, a cursed fortress that exists only during the red light of a LUNAR ECLIPSE.",
	"The Earth prospered! But as the centuries passed, LICH NUR's power grew from within his purgatory, and every BLOODMOON he raised his ARMIES OF THE DEAD to terrorize the world of the living.",
	"As the BLOODMOON TERROR grew, the world of the living needed a MOONSHOT SOLUTION; a new plan to end this horror once and for all.",
	"So they turned to me, WIZARD NODROG, to raise the PALADIN from the dead, that he might reopen CASTLE BLOODMOON, and destroy the LICH NUR forever.",
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
