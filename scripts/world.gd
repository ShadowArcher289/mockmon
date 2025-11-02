extends Node2D
# Trainer & Overworld Sprites: https://www.spriters-resource.com/game_boy_advance/pokemonemerald/
# Battle Menu Sprites: https://eeveeexpo.com/essentials/
# Game Music: https://www.youtube.com/watch?v=uIfD2BKaD2k
func _ready() -> void:
	await get_tree().create_timer(1).timeout;
	get_tree().change_scene_to_file("res://scenes/battle.tscn");
