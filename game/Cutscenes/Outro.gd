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
	"With one final blow, the LICH NUR fell to his death; this time for good",
	""
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
