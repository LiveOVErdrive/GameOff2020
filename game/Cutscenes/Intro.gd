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
	"A thousand years ago, the powerful lich, NUR, ravaged the world with his army of the living dead.",
	"But through the efforts of the mighty Paladin, he was defeated, and magically imprisoned in the Castle Bloodmoon, which vanished from existence in all but the red light of a Lunar Eclipse.",
	"The Earth prospered!, but as centuries passed, and flowers grew upon the forgotten tomb of the Paladin, the Lich labored in his purgatory.",
	"Eventually, the people learned to dread the bloodmoon, for on those rare nights, the armies of the dead rose to plague them once again.",
	"It was on one such night, that the people turned to me, the wizard Nodrog, to raise their long-lost champion, that he might venture into the Castle Bloodmoon, and end the Lich, Nur, once and for all.",
	"And that, dear Paladin, is how you come to be alive again, after one thousand years.  Will you save us again, in our hour of need?"
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
