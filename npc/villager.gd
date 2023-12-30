extends CharacterBody2D

@onready var animations = $dialogueDetection/Dialogue/AnimationPlayer
@onready var dialogue = $dialogueDetection/Dialogue

var playDialogue: bool = false

func _ready():
	dialogue.visible = false

func _physics_process(delta):
	if !playDialogue: 
		dialogue.visible = false
		return
	dialogue.visible = true
	animations.play("talk")
	if Input.is_action_just_pressed("talk"):
		#DialogueManager.show_example_dialogue_balloon(load("res://background.dialogue"),"villager_1")
		global.talked_to_villager_1 = true
		return

func _on_dialogue_body_entered(body):
	if body.name == "goldKnight":
		playDialogue = true



func _on_dialogue_body_exited(body):
	if body.name == "goldKnight":
		playDialogue = false
