extends KinematicBody

const MOUSE_SENS = 0.25
const SPEED = 10
const ACCEL = 20

var velocity

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	velocity = Vector3()

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		rotation_degrees.x = clamp(rotation_degrees.x - MOUSE_SENS * event.relative.y, -90, 90)


func _physics_process(delta):
	var moveVector = Vector3()
	if Input.is_action_pressed("move_forward"):
		moveVector.z -= 1
	if Input.is_action_pressed("move_back"):
		moveVector.z += 1
	if Input.is_action_pressed("move_left"):
		moveVector.x -= 1
	if Input.is_action_pressed("move_right"):
		moveVector.x += 1
		
	moveVector = moveVector.normalized()
	moveVector = moveVector.rotated(Vector3(0, 1, 0), rotation.y)
	velocity = lerp(velocity, moveVector * SPEED, ACCEL * delta)
	
	move_and_slide(velocity)
