extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("blink")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://game/Cutscenes/Intro.tscn")
