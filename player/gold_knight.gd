extends CharacterBody2D

class_name Player

@export var speed = 35
@export var knockbackPower: int = 500
@export var maxHealth = 10

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtBox = $hurtBox
@onready var hurtTimer = $hurtTimer
@onready var weapon = $weapon
@onready var currentHealth: int = maxHealth
@onready var healthBar = $playerLifeBar

var isAttacking: bool = false
var isHurt: bool = false
var enemyCollisions = []
var lastAnimDirection: String = "Down"

func _ready():
	healthBar.value = 100
	weapon.disable()
	effects.play("RESET")

func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
	
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)
	
func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection.normalized() * speed
	
	if Input.is_action_just_pressed("attack"):
		animations.play("attack" + lastAnimDirection)
		isAttacking = true
		weapon.enable()
		await animations.animation_finished
		isAttacking = false
		weapon.disable()
	
func updateAnimation():
	if isAttacking: return
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x<0:
			direction = "Left"
		elif velocity.x>0:
			direction = "Right"
		elif velocity.y<0:
			direction = "Up"
		animations.play("walk"+direction)
		lastAnimDirection = direction

func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized()*knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func hurtByEnemy(area):
	currentHealth -=1
	if currentHealth < 0:
		currentHealth = maxHealth
	
	updateHealth()
	
	isHurt = true
	
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func updateHealth():
	healthBar.value = currentHealth*100/maxHealth
