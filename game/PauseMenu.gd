extends Node2D


onready var audio = $AudioStreamPlayer
onready var control = $Control

var paused = false

func _ready():
	control.visible = false
	audio.playing = false

func _physics_process(delta):
	if get_tree().paused and Input.is_action_just_pressed("ui_accept"):
		get_tree().quit()
	elif Input.is_action_just_pressed("actualQuit"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func unpause():
	audio.playing = false
	control.visible = false
	get_tree().paused = false

func pause():
	audio.playing = true
	control.visible = true
	get_tree().paused = true

