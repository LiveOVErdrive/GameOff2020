extends Spatial

export(bool) var open setget setOpen

onready var animationPlayer = $AnimationPlayer

func setOpen(o):
	open = o

func _ready():
	open = false
	pass # Replace with function body.

# called when player presses the user button on this.
func use():
	if !animationPlayer.is_playing():
		if open:
			animationPlayer.play("close")
		else:
			animationPlayer.play("open")
