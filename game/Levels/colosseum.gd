extends Spatial

onready var roof = $roof
onready var devlight = $devlight
onready var gamelight = $gamelight
onready var playerGate = $playergate
onready var bossGate = $bossgate
onready var crestGate = $crestGate
onready var player = $Player

var bossReleased = false
var bossGateClosed = false

func _ready():
	roof.visible = true
	devlight.visible = false
	gamelight.visible = true

func _on_DoorTriggerArea_area_entered(area):
	if area.get_parent() != player:
		return
	playerGate.open()

func _on_enemyTriggerArea_area_entered(area):
	if bossReleased or area.get_parent() != player:
		return
	bossReleased = true
	bossGate.open()
	playerGate.close()

func _on_enemyTriggerArea2_area_entered(area):
	if bossGateClosed or area.get_parent() != player:
		return
	bossGateClosed = true
	bossGate.close()

func reportDeath(creature):
	crestGate.open()
