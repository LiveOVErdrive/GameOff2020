extends KinematicBody

export(bool) var open setget setOpen

const KICK_SPEED = 20

onready var animationPlayer = $AnimationPlayer
onready var mi1 = $MeshInstance
onready var mi2 = $MeshInstance2
onready var collisionShape = $CollisionShape
onready var sprite = $Sprite3D

var velocity
var isKicking

func doneKicking():
	isKicking = false
	collisionShape.disabled = true

func setOpen(o):
	open = o

func _ready():
	open = false
	collisionShape.disabled = false
	mi1.visible = true
	mi2.visible = true
	sprite.visible = false
	rotation.y = 0
	isKicking = false

func _physics_process(delta):
	if !isKicking:
		return
	move_and_slide(velocity)

# called when player presses the user button on this.
func use():
	if !animationPlayer.is_playing():
		if open:
			animationPlayer.play("close")
		else:
			animationPlayer.play("open")

# called when kicked by the player
func kick(direction):
	mi1.visible = false
	mi2.visible = false
	sprite.visible = true
	animationPlayer.play("kick")
	isKicking = true
	velocity = direction * KICK_SPEED
