extends Node

# GLOBAL GAME STATE SINGLETON FILE

# Constants
const MAX_HP = 100
const BOSS_MAX_HP = 100

# Global Vars
export var playerHealth = MAX_HP setget setPlayerHealth
export var bossHealth = 100 setget setBossHealth
# TODO use an array. Seriously. What is this nonsense?
var piece = [false, false, false]

func setPlayerHealth(h):
	if h > MAX_HP:
		h = MAX_HP
	playerHealth = h

func setBossHealth(h):
	bossHealth = h

func getPiece(n):
	piece[n] = true

func havePiece(n):
	return piece[n]
