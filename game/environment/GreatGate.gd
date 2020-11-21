extends StaticBody

onready var global = get_node("/root/Global")

const bossRoomScene = 'res://game/Levels/BossRoom.tscn'

func _ready():
	pass # Replace with function body.


func use():
	if !canOpen():
		return
	get_tree().change_scene(bossRoomScene)
	
func canOpen():
	return global.havePiece1 and global.havePiece2 and global.havePiece3
