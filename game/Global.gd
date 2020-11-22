extends Node

# GLOBAL GAME STATE SINGLETON FILE

# Constants
const MAX_HP = 100
const BOSS_HP = 100

# Global Vars
export var playerHealth = MAX_HP setget setPlayerHealth
export var bossHealth = 100 setget setBossHealth
# TODO use an array. Seriously. What is this nonsense?
export var havePiece1 = false setget setHavePiece1
export var havePiece2 = false setget setHavePiece2
export var havePiece3 = false setget setHavePiece3

func setPlayerHealth(h):
	if h > MAX_HP:
		h = MAX_HP
	playerHealth = h

func setBossHealth(h):
	bossHealth = h

func setHavePiece1(h):
	havePiece1 = h

func setHavePiece2(h):
	havePiece2 = h

func setHavePiece3(h):
	havePiece3 = h

func getPiece(n):
	if n == 1:
		setHavePiece1(true)
	elif n == 2:
		setHavePiece2(true)
	elif n == 3:
		setHavePiece3(true)

func havePiece(n):
	if n == 1:
		return havePiece1
	elif n == 2:
		return havePiece2
	elif n == 3:
		return havePiece3
