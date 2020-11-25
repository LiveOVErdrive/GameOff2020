extends Spatial


onready var devlight = $DirectionalLight
onready var gamelight = $DirectionalLight2

var hasKey = [false, false]

func _ready():
	devlight.visible = false
	gamelight.visible = true

func playerHasKey(i):
	return hasKey[i]

func acquireKey(i):
	hasKey[i] = true
	
func removeKey(i):
	hasKey[i] = false
