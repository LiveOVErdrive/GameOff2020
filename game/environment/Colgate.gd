extends Spatial

onready var animationPlayer = $AnimationPlayer

func _ready():
	pass # Replace with function body.

func open():
	animationPlayer.play("open")

func close():
	animationPlayer.play("close")
