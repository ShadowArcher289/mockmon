extends TextureButton

@export var current_move = null; ## the current move of this card
@onready var label: Label = $VBoxContainer/Label

func _process(_delta: float) -> void:
	if current_move != null: # update the mockmon_card for the mockmon's data
		label.text = "name: " + current_move.move_name + "\ntype: " + current_move.type + "\nmax pp: " + str(current_move.pp);
	
