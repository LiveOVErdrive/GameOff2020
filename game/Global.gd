extends Node

# GLOBAL GAME STATE SINGLETON FILE

# Constants
const MAX_HP = 100

# Global Vars
export var playerHealth = MAX_HP setget setPlayerHealth
export var havePiece1 = false setget setHavePiece1
export var havePiece2 = false setget setHavePiece2
export var havePiece3 = false setget setHavePiece3

func setPlayerHealth(h):
	playerHealth = h

func setHavePiece1(h):
	havePiece1 = h

func setHavePiece2(h):
	havePiece1 = h

func setHavePiece3(h):
	havePiece1 = h
