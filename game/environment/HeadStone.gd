extends StaticBody

const NUMBER_OF_HEADSTONE_SPRITES = 4

onready var sprite = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var headstoneNum = randi()%NUMBER_OF_HEADSTONE_SPRITES
	sprite.frame = headstoneNum
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
