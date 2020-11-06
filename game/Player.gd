extends KinematicBody

const MOUSE_SENS = 0.25
const SPEED = 10
const ACCEL = 20
const DASH_LENGTH = .75

var velocity
onready var head = $Head
onready var rayCast = $Head/RayCast
onready var rayCastClose = $Head/RayCastClose
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Head/Camera/Sprite3D

export var freezePlayer = false setget setFreezePlayer

func setFreezePlayer(f):
	freezePlayer = f

var isDashing = false
var dashRemaining = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	velocity = Vector3()
	freezePlayer = false
	sprite.frame = 0
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "setPlayer", self)

func _input(event):
	if event is InputEventMouseMotion and !freezePlayer:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		head.rotation_degrees.x = clamp(head.rotation_degrees.x - MOUSE_SENS * event.relative.y, -90, 90)

func _physics_process(delta):
	# Actions
	if Input.is_action_just_pressed("use"):
		var target = rayCast.get_collider()
		if rayCast.is_colliding() and target.has_method("use"):
			target.use()
	
	if isIdle():
		if Input.is_action_pressed("slash"):
			animationPlayer.play("slashWindup")
		elif Input.is_action_pressed("kick"):
			animationPlayer.play("kick")
		elif Input.is_action_pressed("dash"):
			isDashing = true
			dashRemaining = DASH_LENGTH
			animationPlayer.play("dashStart")
			
	if isDashing:
		tryStabCollider()
	
	# Movement
	var moveVector = Vector3()
	if !freezePlayer:
		if Input.is_action_pressed("move_forward"):
			moveVector.z -= 1
		if Input.is_action_pressed("move_back"):
			moveVector.z += 1
		if Input.is_action_pressed("move_left"):
			moveVector.x -= 1
		if Input.is_action_pressed("move_right"):
			moveVector.x += 1
		
	moveVector = moveVector.normalized() if !isDashing else Vector3(0,0,-2)
	moveVector = moveVector.rotated(Vector3(0, 1, 0), rotation.y)
	velocity = lerp(velocity, moveVector * SPEED, ACCEL * delta)
	
	if isDashing:
		#TODO: use a timer instead
		dashRemaining -= delta
		if dashRemaining <=0:
			animationPlayer.play("dashMiss")
			isDashing = false
	
	move_and_slide(velocity)

# sword state machine

# future proofing in case I add an idle animation
func isIdle():
	return !animationPlayer.is_playing()

func doSlash():
	animationPlayer.play("slash")
	
func doSlashBackOrReturn():
	if Input.is_action_pressed("slash"):
		animationPlayer.play("slashBack")
	elif Input.is_action_pressed("kick"):
		animationPlayer.play("kick")
	else:
		animationPlayer.play("leftReturn")

func doSlashOrReturn():
	if Input.is_action_pressed("slash"):
		animationPlayer.play("slash")
	elif Input.is_action_pressed("kick"):
		animationPlayer.play("kick")
	else:
		animationPlayer.play("rightReturn")

func doDash():
	animationPlayer.play("dash")

func trySlashCollider():
	if rayCast.is_colliding():
		var target = rayCast.get_collider()
		if target.has_method("slash"):
			target.slash()

func tryKickCollider():
	if rayCast.is_colliding():
		var target = rayCast.get_collider()
		if target.has_method("kick"):
			target.kick(Vector3(0,0,-1).rotated(Vector3(0, 1, 0), rotation.y))

func tryStabCollider():
	if rayCast.is_colliding():
		isDashing = false
		dashRemaining = 0
		animationPlayer.play("dashStab")
		var target = rayCast.get_collider()
		if target.has_method("stab"):
			target.stab()
