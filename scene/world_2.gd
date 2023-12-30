extends Node2D
@onready var enemies = $TileMap/Enemies

func _ready():
	$TileMap.remove_child(enemies)

func _process(delta):
	pass
	
func _on_area_2d_body_entered(body):
	if body.name == "goldKnight":
		if $TileMap.get_child_count()>1: return
		print("entered")
		$TileMap.call_deferred("add_child",enemies)


func _on_finished_body_entered(body):
	if body.name == "goldKnight":
		get_tree().change_scene_to_file("res://scene/world.tscn")
