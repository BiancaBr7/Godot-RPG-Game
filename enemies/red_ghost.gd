extends CharacterBody2D

var startPosition
var endPosition

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@export var player = Player
@export var maxHealth = 2

@onready var animations = $AnimationPlayer
@onready var healthBar = $healthBar
@onready var currentHealth: int = maxHealth

var isDead: bool = false
var chase: bool = false

func _ready():
	updateHealth()
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	var animationString = "walkUp"
	if velocity.y>0:
		animationString = "walkDown"
	elif velocity.x>0:
		animationString = "walkRight"
	elif velocity.x<0:
		animationString = "walkLeft"
	
	animations.play(animationString)

func _physics_process(delta):
	if isDead: return
	
	if chase:
		var direction = (player.position - self.position).normalized()
		velocity = direction*35
		move_and_slide()
		updateAnimation()
	
	else:
		updateVelocity()
		move_and_slide()
		updateAnimation()


func _on_hurt_box_area_entered(area):
	if area == $hitBox: return
	
	currentHealth -=1
	updateHealth()
	if currentHealth == 0:
		healthBar.queue_free()
		$hitBox.set_deferred("monitorable", false)
		isDead = true
		animations.play("death")
		await animations.animation_finished
		queue_free()
		return

func updateHealth():
	if !healthBar: return
	healthBar.value = currentHealth*100/maxHealth

func _on_player_detection_body_entered(body):
	if body.name == "goldKnight":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "goldKnight":
		chase = false
