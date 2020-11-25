extends KinematicBody

export(bool) var open setget setOpen
export(int) var keyNum setget setKeyNum

const KICK_SPEED = 10

onready var animationPlayer = $AnimationPlayer
onready var mi1 = $MeshInstance
onready var mi2 = $MeshInstance2
onready var collisionShape = $CollisionShape

var level
var colorname
var player

func setOpen(o):
	open = o

func setKeyNum(kn):
	keyNum = kn

func _ready():
	add_to_group("collectibles")
	open = false
	collisionShape.disabled = false
	mi1.visible = true
	mi2.visible = true
	rotation.y = 0
	level = get_parent().get_parent()
	colorname = generateColorName()
	setTexture()

func setTexture():
	if keyNum == 0:
		return # this is default
	else:
		var texture = load("res://assets/keydoorBlue.png")
		mi1.material_override.set_param("albedo_texture", texture)
		mi2.material_override.set_param("albedo_texture", texture)

func setPlayer(p):
	player = p

# called when player presses the user button on this.
func use():
	if !animationPlayer.is_playing() and canOpen():
		if open:
			return
		else:
			level.removeKey(keyNum)
			player.updateHud()
			animationPlayer.play("open")

# called when kicked by the player
func kick(direction):
	pass
	
func getTooltip():
	if !open:
		return colorname + " DOOR\nLOCKED - needs " + colorname + "KEY"
	else:
		return colorname + "DOOR\nopen"
	
func canOpen():
	return level.playerHasKey(keyNum)

func generateColorName():
	if keyNum == 0:
		return "RED"
	else:
		return "BLUE"
