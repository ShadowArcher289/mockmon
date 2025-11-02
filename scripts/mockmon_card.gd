extends Button

@export var current_mockmon = null; ## the mockmon this card will be displaying

@onready var mockmon_sprite: TextureRect = $HBoxContainer/MarginContainer/MockmonSprite
@onready var mockmon_name: Label = $HBoxContainer/MarginContainer2/VBoxContainer/MockmonName
@onready var hp_bar: ProgressBar = $HBoxContainer/MarginContainer2/VBoxContainer/HpBar
@onready var panel: Panel = $HBoxContainer/MarginContainer/Panel
@onready var mockmon_types: Label = $HBoxContainer/MarginContainer2/VBoxContainer/MockmonTypes

func _process(_delta: float) -> void:
	if current_mockmon != null: # update the mockmon_card for the mockmon's data
		mockmon_name.text = current_mockmon.MOCKMON_NAME; # use once Mockmon.gd is made
		#mockmon_name.text = "Name"; # temporary 
		mockmon_sprite.texture = current_mockmon.MOCKMON_SPRITE;
		#mockmon_sprite.texture = preload("res://icon.svg");
		hp_bar.value = current_mockmon.currentHp;
		hp_bar.max_value = current_mockmon.MAX_HP;
		
		mockmon_types.text = "";
		for i in range(current_mockmon.TYPE.size()):
			mockmon_types.text += (current_mockmon.TYPE[i] + " ");
		
		if current_mockmon.currentHp <= 0:
			panel.show();
		elif current_mockmon.currentHp > 0:
			panel.hide();
