extends Node2D
@onready var enemies = $TileMap/Enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	$TileMap.remove_child(enemies)
	#DialogueManager.show_example_dialogue_balloon(load("res://background.dialogue"),"background")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
		
func _on_area_2d_body_entered(body):
	if body.name == "goldKnight":
		if $TileMap.get_child_count()>1: return
		if global.talked_to_villager_1:
			DialogueManager.show_example_dialogue_balloon(load("res://background.dialogue"),"blueGhostIntro")
			DialogueManager.show_example_dialogue_balloon(load("res://background.dialogue"),"redGhostIntro")
			global.blueIntro = true
			global.redIntro = true
			$TileMap.call_deferred("add_child",enemies)


func _on_finished_body_entered(body):
	if body.name == "goldKnight":
		if global.talked_to_villager_1:
			get_tree().change_scene_to_file("res://scene/world_2.tscn")
