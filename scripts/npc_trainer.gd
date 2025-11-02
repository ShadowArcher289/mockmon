extends Node2D

@onready var literal_rock: Node = $LiteralRock
@onready var dripped_out_rat: Node = $DrippedOutRat

@export var mockmon_party: Array[Node] = [];

@export var current_mockmon: Node = dripped_out_rat

@export var enemy_current_mockmon: Node = literal_rock;


func _ready() -> void:
	current_mockmon = dripped_out_rat;
	enemy_current_mockmon = literal_rock;

func _process(_delta: float) -> void:
	pass

func switch_members(mon_out: Node2D, mon_in: Node2D) :
	var weakness = false;
	var super_mon;
	if(mon_in.death == true) : ## If the mon is dead, switch in a different mon with a super effective move
		for i in range(mockmon_party.size()) :
			if mockmon_party[i] == mon_in :
				continue;
			super_mon = mockmon_party[i]
			for j in range(super_mon.moves.size()) :
				weakness = Globals.is_weak(super_mon.moves[j].type, enemy_current_mockmon);
				if weakness == true : ## If a different mon in the party has a super effective move, switch to that mon (whichever comes first)
					current_mockmon = mockmon_party[i];
					current_mockmon.hide();
					SignalBus.npc_move_finished.emit("NPC switched to " + current_mockmon.MOCKMON_NAME);
					return;
		if(weakness == false) :	 ## If no other mon has a super effective move, randomly send in another mon
			var random_integer = randi_range(0, mockmon_party.size()-1);
			while(mockmon_party[random_integer] == mon_in) :
				random_integer = randi_range(0, mockmon_party.size()-1);
			current_mockmon = mockmon_party[random_integer];
			current_mockmon.hide();
			SignalBus.npc_move_finished.emit("NPC switched to " + current_mockmon.MOCKMON_NAME)
			return;
	if(mon_out == null) : ## If there isn't another mon to send out, randomly send a mon out
		var random_integer = randi_range(0, mockmon_party.size()-1);
		while(mockmon_party[random_integer] == mon_in) :
			random_integer = randi_range(0, mockmon_party.size()-1);
		current_mockmon.hide();
		current_mockmon = mockmon_party[random_integer];
		SignalBus.npc_move_finished.emit("NPC switched to " + current_mockmon.MOCKMON_NAME)
		return;
	else : ## Send out a super effective mon
		current_mockmon = mon_out
		current_mockmon.hide();
		SignalBus.npc_move_finished.emit("NPC switched to " + current_mockmon.MOCKMON_NAME)
		return;

func make_move(enemy_mockmon: Node2D) :
	print("NPC Starts Move")
	enemy_current_mockmon = enemy_mockmon;
	var weakness = false
	var resistance = false
	var good_move = "";
	var super_mon;
	var chosen_move;
	if current_mockmon.death == true :
		switch_members(null, current_mockmon);
	for i in range(current_mockmon.moves.size()): ## iterates through AI trainer's moves
		weakness = Globals.is_weak(current_mockmon.moves[i].type, enemy_current_mockmon);
		if weakness == true :
			good_move = current_mockmon.moves[i]; ## If they have a move that's super-effective, attack
			if good_move.is_category("special"):
				current_mockmon.use_move(good_move, enemy_current_mockmon)
				SignalBus.npc_move_finished.emit("NPC's " + current_mockmon.MOCKMON_NAME + " used " + good_move.move_name + "!");
				return;
			else :
				current_mockmon.use_move(good_move, enemy_current_mockmon)
				SignalBus.npc_move_finished.emit("NPC's " + current_mockmon.MOCKMON_NAME + " used " + good_move.move_name + "!");
				return;
	if weakness == false : ## If the current mon has no super-effective moves, check for its party member
		for i in range(mockmon_party.size()):
			super_mon = mockmon_party[i]
			for j in range(current_mockmon.moves.size()):
				weakness = Globals.is_weak(super_mon.moves[j].type, enemy_current_mockmon);
				if weakness == true : ## If a different mon in the party has a super effective move, switch to that mon (whichever comes first)
					switch_members(super_mon, current_mockmon)
					return;
	if weakness == false : ## If no mons in the party have super effective moves, check for resistances 
		for i in range(current_mockmon.moves.size()) :
			resistance = Globals.is_resist(current_mockmon.moves[i].type, enemy_current_mockmon)
			if resistance == true : ## If the player's mon resists any of the current AI trainer's moves, switch out to a random pokemon
				switch_members(null, current_mockmon)
				return;
	if resistance == false : ## If none of these are true, the AI will just use a random move
		var random_integer = randi_range(1, 4);
		chosen_move = current_mockmon.moves[random_integer-1];
		current_mockmon.use_move(chosen_move, enemy_current_mockmon)
		SignalBus.npc_move_finished.emit("NPC's " + current_mockmon.MOCKMON_NAME + " used " + chosen_move.move_name + "!")
		return;
