extends Node2D

@onready var literal_rock: Node2D = $LiteralRock

@export var mockmon_party: Array[Node2D] = [];

@export var current_mockmon: Node2D;

<<<<<<< HEAD
@export var enemy_current_mockmon: Node2D = literal_rock;

func _ready() -> void:
	enemy_current_mockmon = literal_rock;
	if(enemy_current_mockmon.has_method())
	pass

func _process(delta: float) -> void:
	pass
=======
#@export var 
#
#func _ready() -> void:
	#
#
#func _process(delta: float) -> void:
	
>>>>>>> 88ec0441561842600f574fa93ad5004269c33e98
