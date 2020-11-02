extends KinematicBody

const MOVE_SPEED = 15
const ACCEL = 20
const JUMP_SPEED = 40
const GRAVITY = 4
const MAX_FALL_SPEED = -20
const COYOTE_FACTOR = 1.1 # 0.5 would be "fair"


onready var groundDetector = $GroundDetector
onready var groundDetector2 = $GroundDetector2
onready var groundDetector3 = $GroundDetector3


func _ready():
	groundDetector2.translation.x = -COYOTE_FACTOR
	groundDetector3.translation.x = COYOTE_FACTOR
	
var velocity = Vector3()

func _physics_process(delta):
	
	# WALKING
	var xInput = 0
	if Input.is_action_pressed("ui_left"):
		xInput -= 1
	if Input.is_action_pressed("ui_right"):
		xInput += 1
	velocity.x = lerp(velocity.x, xInput*MOVE_SPEED, ACCEL*delta)

	# GRAVITY
	velocity.y = lerp(velocity.y, MAX_FALL_SPEED, GRAVITY*delta)

	velocity = move_and_slide(velocity)

	# JUMPING
	if Input.is_action_just_pressed("jump") and grounded():
		velocity.y = JUMP_SPEED
	
func grounded():
	return groundDetector.is_colliding() or groundDetector2.is_colliding() or groundDetector3.is_colliding()
