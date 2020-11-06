extends KinematicBody

const SPEED = 10
const MIN_DIST_TO_PLAYER = 3
const MAX_DIST_TO_PLAYER = 7
const VIEW_DISTANCE = 20
const CORNER_CUT_DIST = 1

onready var nav = get_parent()
onready var player
onready var rayCast = $RayCast

enum {
	IDLE,
	ADVANCE,
	RETREAT,
	ATTACK
}

var path = []
var currentPathNode = 0
var state

func _ready():
	add_to_group("enemies")
	state = IDLE

func setPlayer(p):
	print("set player")
	player = p

func _physics_process(delta):
	if !player:
		return
	if state == IDLE:
		# TODO: not "seeing" the player this way
		rayCast.cast_to = player.translation
		if rayCast.get_collider() == player:
			var distanceToPlayer = getDistanceToPlayer()
			if distanceToPlayer < VIEW_DISTANCE:
				if distanceToPlayer > MAX_DIST_TO_PLAYER:
					advance()
				elif distanceToPlayer > MIN_DIST_TO_PLAYER:
					attack()
				else:
					retreat()
	elif state == ATTACK:
		# TODO check if we are doing an attack animation first
		var distanceToPlayer = getDistanceToPlayer()
		if distanceToPlayer > MAX_DIST_TO_PLAYER:
			advance()
		elif distanceToPlayer < MIN_DIST_TO_PLAYER:
			retreat()
		elif distanceToPlayer > VIEW_DISTANCE:
			idle()
		else:
			pass #TODO do an attack animation
	elif state == RETREAT:
		var fleeDirection = getVectorToPlayer().normalized() * -1
		fleeDirection.y = 0 # just to make sure
		move_and_slide(fleeDirection * SPEED)
	elif state == ADVANCE:
		var distanceToPlayer = getDistanceToPlayer()
		if distanceToPlayer < MIN_DIST_TO_PLAYER:
			retreat()
		elif distanceToPlayer < MAX_DIST_TO_PLAYER:
			attack()
		elif distanceToPlayer > VIEW_DISTANCE:
			idle()
		elif currentPathNode >= path.size:
			# gotta chase em again
			getPathToPlayer()
		else:
			var moveDirection = path[currentPathNode] - global_transform.origin
			if moveDirection.length < CORNER_CUT_DIST:
				currentPathNode += 1
			else:
				move_and_slide(moveDirection.normalized() * SPEED)
		
		

func getVectorToPlayer():
	return player.translation - translation

func getDistanceToPlayer():
	return getVectorToPlayer().length()

func advance():
	print("ADVANCE")
	state = ADVANCE
	getPathToPlayer()

func attack():
	print("ATTACK")
	state = ATTACK

func retreat():
	print("RETREAT")
	state = RETREAT

func idle():
	print("IDLE")
	state = IDLE

func getPathToPlayer():
	path = nav.get_simple_path(global_transform.origin, player.translation)
	currentPathNode = 0
