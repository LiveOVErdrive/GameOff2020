extends KinematicBody

const MOUSE_SENS = 0.25
const SPEED = 10
const ACCEL = 20
const DASH_LENGTH = .75
const BLOOD_SCALE = 5
const FEATURE_FLAG_DASH = false

var velocity

onready var global = get_node("/root/Global")

onready var head = $Head
onready var rayCast = $Head/RayCast
onready var rayCastClose = $Head/RayCastClose
onready var animationPlayer = $AnimationPlayer
onready var cameraAnimationPlayer = $Head/CameraAnimationPlayer
onready var sprite = $Head/Camera/Sprite3D
onready var blood = $Head/Blood
onready var deathscreen = $CanvasLayer/Control/YouDied
onready var healthbar = $CanvasLayer/Control/Healthbar
onready var crest1 = $CanvasLayer/Control/crests/Crest1
onready var crest2 = $CanvasLayer/Control/crests/Crest2
onready var crest3 = $CanvasLayer/Control/crests/Crest3
onready var tooltip = $CanvasLayer/Control/Pixelator/tooltip
onready var dialogue = $CanvasLayer/Control/Pixelator/Dialogue
onready var dialoguePlayer = $DialogueAnimationPlayer
onready var crosshair = $CanvasLayer/Control/Crosshair
onready var redkey = $CanvasLayer/Control/keys/redkey
onready var bluekey = $CanvasLayer/Control/keys/bluekey
onready var colorrect = $CanvasLayer/Control/ColorRect
onready var teleportAnimationPlayer = $EffectAnimationPlayer

export var freezePlayer = false setget setFreezePlayer

func setFreezePlayer(f):
	freezePlayer = f

var isDashing = false
var dashRemaining = 0
var dead = false
var level

func _ready():
	level = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head.rotation = Vector3()
	head.translation.y = .25
	velocity = Vector3()
	freezePlayer = false
	deathscreen.frame = 0
	sprite.frame = 0
	updateHud()
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "setPlayer", self)
	get_tree().call_group("collectibles", "setPlayer", self)
	tooltip.text = ""
	clearDialogue()
	colorrect.color = Color(0,0,0,0)

func _input(event):
	if event is InputEventMouseMotion and !freezePlayer:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		head.rotation_degrees.x = clamp(head.rotation_degrees.x - MOUSE_SENS * event.relative.y, -90, 90)

func _physics_process(delta):
	# System
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		global.setBossHealth(global.MAX_HP)
		get_tree().reload_current_scene()
		
	if dead:
		return

	var target = rayCast.get_collider()
	if target:
		if target.has_method("getTooltip"):
			tooltip.text = target.getTooltip()
		if Input.is_action_just_pressed("use") and target.has_method("use"):
			target.use()
	elif tooltip.text != "":
		tooltip.text = ""
	
	if isIdle():
		if Input.is_action_pressed("slash"):
			animationPlayer.play("slashWindup")
		elif Input.is_action_pressed("kick"):
			animationPlayer.play("kick")
		elif Input.is_action_pressed("dash") and FEATURE_FLAG_DASH:
			isDashing = true
			dashRemaining = DASH_LENGTH
			animationPlayer.play("dashStart")

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
		var dashTarget = rayCastClose.get_collider()
		if dashTarget and !dashTarget.is_in_group("projectiles"):
			doStab(dashTarget)
		else:
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

func _on_SwordArea_area_entered(area):
	var target = area.get_parent()
	if target == self:
		return
	if target.has_method("slash"):
		target.slash()

func _on_KickArea_area_entered(area):
	var target = area.get_parent()
	if target == self:
		return
	if target.has_method("kick"):
		target.kick(Vector3(0,0,-1).rotated(Vector3(0, 1, 0), rotation.y))

func tellBlockersToBlock():
	get_tree().call_group("blockers", "playerAttacking")

# TODO use a raycast again
func doStab(target):
	isDashing = false
	dashRemaining = 0
	animationPlayer.play("dashStab")
	if target.has_method("stab"):
		target.stab()

# outside effects:

# take damage
func damage(d: int):
	if dead:
		return
	blood.amount = BLOOD_SCALE * d
	cameraAnimationPlayer.play("take_damage")
	global.playerHealth -= d
	if global.playerHealth <= 0:
		die()
	updateHud()

func die():
	dead = true
	blood.amount = BLOOD_SCALE * 100
	animationPlayer.play("rightExit")
	cameraAnimationPlayer.play("die")
	
func updateHud():
	crest1.visible = global.havePiece(0)
	crest2.visible = global.havePiece(1)
	crest3.visible = global.havePiece(2)
	redkey.visible = level.has_method("playerHasKey") and level.playerHasKey(0)
	bluekey.visible = level.has_method("playerHasKey") and level.playerHasKey(1)
	var hpPercent = float(global.playerHealth)/float(global.MAX_HP)
	healthbar.rect_scale = Vector2(hpPercent, 1)

func clearDialogue():
	dialogue.visible = false
	dialogue.text = ""
	crosshair.visible = true

func playDialogue(s):
	dialogue.percent_visible = 0
	dialogue.text = s
	crosshair.visible = false
	dialogue.visible = true
	dialoguePlayer.play("print")

func teleportHome():
	teleportAnimationPlayer.play("teleport")
	
func fadeIn():
	teleportAnimationPlayer.play("fadein")

func doTeleport():
	get_tree().change_scene("res://game/Levels/HubWorld.tscn")
