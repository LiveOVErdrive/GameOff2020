extends KinematicBody

const DAMAGE = 10

var velocity = Vector3()
var player
var source

func setSource(s):
	source = s

func setVelocity(v):
	velocity = v

func _ready():
	add_to_group("projectiles")

func setPlayer(p):
	player = p 

func _physics_process(delta):
	if !player:
		return

	var col = move_and_collide(velocity * delta)
	if col:
		doHit(col.collider)

func doHit(target):
	if target == source or target.is_in_group("enemies"):
		return
	if target.has_method("damage"):
		target.damage(DAMAGE)
	queue_free() #delete self

