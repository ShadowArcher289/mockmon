extends Node2D

@onready var player_trainer: CharacterBody2D = $Player
@onready var npc_trainer: Node2D = $NpcTrainer

var turn_count = 0; ## the turn count
var battling = true;

func _ready() -> void:
	battle(player_trainer, npc_trainer);
	
	SignalBus.connect("player_done_with_battle", _end_battle_player); # connect done with battle signals
	SignalBus.connect("npc_done_with_battle", _end_battle_npc);


func battle(player: CharacterBody2D, npc: Node2D) -> void: ## starts a battle between the two characters
	while battling:
		
		# check which player's pokemon has the faster speed, if tied, pick random.
		if npc.current_mockmon.BASE_SPEED > player.current_mockmon.BASE_SPEED:
			npc.make_move();
			await SignalBus.npc_move_finished;
			player.make_move();
			await SignalBus.player_move_finished;
		if npc.current_mockmon.BASE_SPEED < player.current_mockmon.BASE_SPEED:
			player.make_move();
			await SignalBus.player_move_finished;
			npc.make_move();
			await SignalBus.npc_move_finished;
		else: # do randomly
			var rand_num = randi_range(1, 2);
			if rand_num == 1:
				npc.make_move();
				await SignalBus.npc_move_finished;
				player.make_move();
				await SignalBus.player_move_finished;
			else:
				player.make_move();
				await SignalBus.player_move_finished;
				npc.make_move();
				await SignalBus.npc_move_finished;
		
		turn_count += 1;
	
func _end_battle_player() -> void: ## player lost/quit the battle
	battling = false;
	print_debug("NPC Won! in [" + turn_count + "] turns!");
	
func _end_battle_npc() -> void: ## npc lost/quit the battle
	battling = false;
	print_debug("Player Won! in [" + turn_count + "] turns!");
