@tool
extends EditorPlugin

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("Mockmon", "Node2D", preload("res://scripts/Mockmon.gd"), preload("res://icon.svg"));



func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("Mockmon");
