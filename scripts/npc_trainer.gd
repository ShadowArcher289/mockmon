extends Node2D

@onready var literal_rock: Node = $LiteralRock
@onready var dripped_out_rat: Node = $DrippedOutRat

@export var mockmon_party: Array[Node] = [];

@export var current_mockmon: Node = dripped_out_rat

@export var enemy_current_mockmon: Node = literal_rock;


func _ready() -> void:
	current_mockmon = dripped_out_rat;
	enemy_current_mockmon = literal_rock;
	make_move();
	

func _process(_delta: float) -> void:
	pass

func make_move() :
	var weakness = false
	var resistance = false
	var good_move = "";
	var super_mon;
	var chosen_move;
	for i in range(current_mockmon.moves.size()) :
		weakness = Globals.is_weak(current_mockmon.moves[i].type, enemy_current_mockmon);
		if weakness == true :
			good_move = current_mockmon.moves[i];
			if good_move.is_category("special") :
				enemy_current_mockmon.take_damage(current_mockmon.BASE_SPEC_ATK, good_move)
				SignalBus.npc_move_finished.emit()	
			else :
				enemy_current_mockmon.take_damage(current_mockmon.BASE_ATK, good_move)
				SignalBus.npc_move_finished.emit()
					
	if weakness == false :
		for i in range(mockmon_party.size()) :
			super_mon = mockmon_party[i]
			for j in range(current_mockmon.moves.size()) :
				weakness = Globals.is_weak(super_mon.moves[j], enemy_current_mockmon);
				if weakness == true :
					#switch_members()
					SignalBus.npc_move_finished.emit()
	if weakness == false :
		for i in range(current_mockmon.moves.size()) :
			resistance = Globals.is_resist(current_mockmon.moves[i].type, enemy_current_mockmon)
			if resistance == true :
				#switch_members()
				SignalBus.npc_move_finished.emit()
	else :
		var random_integer = randi_range(1, 4);
		chosen_move = current_mockmon.moves[random_integer];
		if chosen_move.is_category("special") :
				enemy_current_mockmon.take_damage(current_mockmon.BASE_SPEC_ATK, good_move)
				SignalBus.npc_move_finished.emit()	
		else :
				enemy_current_mockmon.take_damage(current_mockmon.BASE_ATK, good_move)
				SignalBus.npc_move_finished.emit()
	
				
		
