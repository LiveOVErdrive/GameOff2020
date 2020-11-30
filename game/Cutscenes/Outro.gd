extends Node2D


onready var animationPlayer = $AnimationPlayer
onready var text = $Control/Sprite/Text
onready var space = $Control/Sprite/Spacebar
onready var sprite = $Control/Sprite
onready var creditsText = $Control/Sprite/Text2
onready var colorrect = $Control/Sprite/ColorRect
onready var outroAudio = $outroAudio
onready var creditsAudio = $creditsAudio
onready var phil = $phil

var allowSkip = false
var frame = 0

func _ready():
	text.text = slideTexts[frame]
	animationPlayer.play("DisplayText")
	space.visible = false
	frame = 0
	sprite.frame = frame
	colorrect.visible = false
	creditsText.visible = false
	creditsText.percent_visible = 0
	phil.stream = load(slideAudio[frame])
	phil.playing = true


const slideTexts = [
	"With a final blow, the LICH NUR died - for good",
	"From that night on, the BLOODMOON remained silent; nothing more than an astronomical oddity.",
	"The world was safe.  And I, the PALADIN, finally knew peace."
]

const slideAudio = [
	"res://assets/audio/outro1.wav",
	"res://assets/audio/outro2.wav",
	"res://assets/audio/outro3.wav",
]

const credits = [
	"THE END",
	"Created for GITHUB GAME JAM 2020 by Phil Breczinski",
	"Special Thanks to Kyle Fay for voicing NODROG/NUR",
	"Thank you to Richard Anderson, Alex Brick, Sam Collins, and Nathan Gaida for playtesting.",
	"and thank YOU for playing BLOODMOON."
]

func _physics_process(delta):
	# System
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	if allowSkip and Input.is_action_just_pressed("ui_accept"):
		space.visible = false
		allowSkip = false
		frame += 1
		if frame >= slideTexts.size():
			text.visible = false
			space.visible = false
			colorrect.visible = true
			creditsText.visible = true
			frame = 0
			allowSkip = false
			animationPlayer.play("credits")
			return
		text.percent_visible = 0
		text.text = slideTexts[frame]
		sprite.frame = frame
		animationPlayer.play("DisplayText")
		phil.stream = load(slideAudio[frame])
		phil.playing = true

func waitForPlayer():
	space.visible = true
	allowSkip = true
	animationPlayer.play("spacebar")
	
func showNextCredits():
	if frame == 1:
		outroAudio.playing = false
		creditsAudio.playing = true
	creditsText.visible = true
	creditsText.text = credits[frame]
	frame += 1

func hideCredits():
	creditsText.visible = false

func exit():
	get_tree().quit()
