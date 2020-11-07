extends KinematicBody

const SPEED = 5
const MIN_DIST_TO_PLAYER = 3
const MED_DIST_TO_PLAYER = 5
const MAX_DIST_TO_PLAYER = 7
const VIEW_DISTANCE = 20
const CORNER_CUT_DIST = 1

onready var nav = get_parent()
onready var player

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

	var distanceToPlayer = getDistanceToPlayer()

	if state == IDLE:
		if distanceToPlayer < VIEW_DISTANCE:
			advance()
	elif state == ATTACK:
		# TODO check if we are doing an attack animation first
		if distanceToPlayer < MIN_DIST_TO_PLAYER:
			retreat()
		elif distanceToPlayer > MAX_DIST_TO_PLAYER:
			advance()
		else:
			pass #TODO do an attack animation
	elif state == RETREAT:
		if distanceToPlayer > MED_DIST_TO_PLAYER:
			attack()
		else:
			var fleeDirection = getVectorToPlayer().normalized() * -1
			fleeDirection.y = 0 # just to make sure
			move_and_slide(fleeDirection * SPEED)
	elif state == ADVANCE:
		if distanceToPlayer < MED_DIST_TO_PLAYER:
			attack()
		else:
			if currentPathNode >= path.size():
				getPathToPlayer()
			var moveDirection = path[currentPathNode] - global_transform.origin
			if moveDirection.length() < CORNER_CUT_DIST:
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
