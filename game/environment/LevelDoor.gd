extends StaticBody

export var targetScene : String setget setTargetScene
export var tooltip : String setget setTooltip

func setTargetScene(ts):
	targetScene = ts

func setTooltip(tt):
	tooltip = tt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func use():
	get_tree().change_scene(targetScene)

func getTooltip():
	return tooltip
