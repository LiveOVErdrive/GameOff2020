extends StaticBody

onready var global = get_node("/root/Global")

const bossRoomScene = 'res://game/Levels/BossRoom.tscn'

func _ready():
	pass # Replace with function body.


func use():
	if !canOpen():
		return
	get_tree().change_scene(bossRoomScene)
	
func getTooltip():
	if !canOpen():
		return "CASTLE BLOODMOON\nThe gate is sealed until all 3 shards of the PALADIN CREST are recovered."
	else:
		return "CASTLE BLOODMOON"
	
func canOpen():
	return global.havePiece1 and global.havePiece2 and global.havePiece3
