extends KinematicBody

var player
var fireballResource = preload("res://game/projectiles/Fireball.tscn")

const PROJECTILE_START_DISTANCE = 1
const PROJECTILE_START_HEIGHT = 1.3
const FIRING_WIDTH = .2
const PROJECTILE_SPEED = 20
const CORNER_CUT_DIST = 1
const SPEED = 8
const ATTACK_RANGE = 20
const CONSECUTIVE_PROJECTILES = 3
const BLOCK_CYCLES_BEFORE_BURST = 3
const BURST_PROJECTILES = 20
const KICK_STRENGTH = 10
const KICK_DECCEL = 10
const DEMON_ATTACK_RANGE = 2

enum {
	WIZARD,
	ATTACK,
	BLOCK,
	ADVANCE,
	KICKED
}

var path = []
var currentPathNode = 0
var state = WIZARD
var repeatCounter = 0
var kickDirection = Vector3()
var kickSpeed = 0
var blocking = false
var isDemon = false

onready var global = get_node("/root/Global")
onready var animationPlayer = $AnimationPlayer
onready var raycast = $RayCast
onready var nav = get_parent()
onready var level = get_parent().get_parent()
onready var lichHurtbox = $Area/CollisionShape
onready var demonHurtbox = $demonHurtbox/CollisionShape
onready var hurtAnimator = $HurtAnimator
onready var demonHitbox = $demonHitbox/CollisionShape
onready var sprite = $Sprite3D
onready var light = $GreenLight
onready var particles = $Particles
onready var kyle = $kyle

func _ready():
	add_to_group("enemies")
	animationPlayer.play("wizard")
	flashWhiteOff()
	light.visible = false
	particles.visible = global.particlesEnabled
	particles.emitting = false

func setPlayer(p):
	player = p

func setBlocking(b: bool):
	blocking = b

func _physics_process(delta):
	if !player:
		return
	
	# Manual Billboard
	var playerPoint = player.translation
	playerPoint.y = translation.y
	look_at(playerPoint, Vector3(0,1,0))
	
	var distanceToPlayer = getDistanceToPlayer()
	
	var unitVecToPlayer = getVectorToPlayer()
	unitVecToPlayer.y = 0
	unitVecToPlayer = unitVecToPlayer.normalized()
	raycast.cast_to = translation + unitVecToPlayer * ATTACK_RANGE
	
	# State Machine
	if state == WIZARD:
		pass
	elif state == ATTACK:
		if !animationPlayer.is_playing():
			if isDemon:
				animationPlayer.play("demonAttack")
			elif repeatCounter > 0:
				animationPlayer.play("doubleshot")
				repeatCounter -= 1
			else:
				block()
	elif state == BLOCK:
		if !animationPlayer.is_playing():
			if repeatCounter > 0:
				animationPlayer.play("holdblock")
				repeatCounter -= 1
			else:
				setBlocking(false)
				animationPlayer.play("burst")
	elif state == ADVANCE:
		if !isDemon and canSeePlayer():
			attack()
		elif isDemon and getDistanceToPlayer() < DEMON_ATTACK_RANGE:
			attack()
		else:
			if currentPathNode >= path.size():
				getPathToPlayer()
			var moveDirection = path[currentPathNode] - global_transform.origin
			moveDirection.y = 0
			if moveDirection.length() < CORNER_CUT_DIST:
				currentPathNode += 1
			else:
				move_and_slide(moveDirection.normalized() * SPEED)

# Interface Stuffs

func kick(direction):
	blocking = false
	kickDirection = direction
	kickSpeed = KICK_STRENGTH
	if !isDemon:
		animationPlayer.play("kicked")
	else:
		animationPlayer.play("demonKicked")
	state = KICKED
	
func slash():
	if blocking:
		riposte()
		# TODO return somtehing to make the player staggered for a second
	else:
		damage(5)
func stab():
	if blocking:
		riposte()
	else:
		damage(2)

func riposte():
	animationPlayer.play("riposte")
	player.damage(10)
	
func damage(d):
	global.bossHealth -= d
	player.updateHud()
	if global.bossHealth <= 0:
		if !isDemon:
			becomeDemon()
		else:
			die()
	else:
		if !isDemon:
			animationPlayer.play("hurt")
		else:
			animationPlayer.play("demonHurt")

func becomeDemon():
	isDemon = true
	state = WIZARD
	invuln(true)
	animationPlayer.play("transformAgain")
	light.visible = true

func replenishHealth():
	global.bossHealth = global.BOSS_MAX_HP
	
func invuln(b: bool):
	if b:
		demonHurtbox.disabled = true
		lichHurtbox.disabled = true
		demonHitbox.disabled = true
	else:
		demonHurtbox.disabled = !isDemon
		lichHurtbox.disabled = isDemon

# state changes

func advance():
	state = ADVANCE
	getPathToPlayer()
	if !isDemon:
		animationPlayer.play("idle")
	else:
		animationPlayer.play("demonWalk")

func attack():
	state = ATTACK
	if !global.inBossFight:
		global.inBossFight = true
		player.updateHud()
	if !isDemon:
		repeatCounter = CONSECUTIVE_PROJECTILES - 1
		animationPlayer.play("doubleshot")
	else:
		animationPlayer.play("demonAttack")

func block():
	repeatCounter = BLOCK_CYCLES_BEFORE_BURST
	state = BLOCK
	animationPlayer.play("startblock")
	kyle.stream = load("res://assets/audio/wizard/lich_block.wav")
	kyle.playing = true

func canSeePlayer():
	var col = raycast.get_collider()
	return col == player

func transform():
	animationPlayer.play("transform")
	
func die():
	state = WIZARD
	animationPlayer.play("demonDie")
	player.fadeToFinish()

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()

func shootOne(offsetFactor: float):
	var fireDirection = getVectorToPlayer()
	fireDirection.y = 0
	fireDirection = fireDirection.normalized()
	var arrow = fireballResource.instance()
	var sideDirection = Vector3(fireDirection.z, 0, fireDirection.x) * offsetFactor
	arrow.translation = translation + fireDirection * PROJECTILE_START_DISTANCE + sideDirection * FIRING_WIDTH
	arrow.translation.y = PROJECTILE_START_HEIGHT
	arrow.setPlayer(player)
	arrow.setVelocity(fireDirection * PROJECTILE_SPEED)
	arrow.setSource(self)
	get_parent().get_parent().add_child(arrow)
	
func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0

func burst():
	var degreeDifference = PI*2 / BURST_PROJECTILES
	var launchPoint = Vector3(0,0,-1)
	for n in range(BURST_PROJECTILES):
		# TODO create the projectiles at the different rotations
		launchPoint = launchPoint.rotated(Vector3(0,1,0), degreeDifference)
		var arrow = fireballResource.instance()
		arrow.translation = translation + launchPoint * PROJECTILE_START_DISTANCE
		arrow.translation.y = PROJECTILE_START_HEIGHT
		arrow.setPlayer(player)
		arrow.setVelocity(launchPoint * PROJECTILE_SPEED)
		arrow.setSource(self)
		get_parent().get_parent().add_child(arrow)
	advance()

func _on_demonHitbox_area_entered(area):
	var target = area.get_parent()
	if target != player:
		return
	target.damage(20)

func flashWhite():
	sprite.modulate = Color(10,10,10,10)

func flashWhiteOff():
	sprite.modulate = Color(1,1,1,1)
