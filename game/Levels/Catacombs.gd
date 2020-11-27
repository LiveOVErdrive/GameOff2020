extends Spatial

onready var roof = $Walls2

var hasKey = [false, false]

func _ready():
	roof.visible=true

func playerHasKey(i):
	return hasKey[i]

func acquireKey(i):
	hasKey[i] = true
	
func removeKey(i):
	hasKey[i] = false
