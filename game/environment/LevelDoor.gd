extends StaticBody


export var targetScene : String setget setTargetScene

func setTargetScene(ts):
	targetScene = ts

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func use():
	print("use")
	get_tree().change_scene(targetScene)
