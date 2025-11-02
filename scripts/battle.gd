extends Control

@onready var player_trainer: CharacterBody2D = $Player
@onready var npc_trainer: Node2D = $NpcTrainer

@onready var battle_options: HBoxContainer = $BattleOptions
@onready var switch_mockmon_box: MarginContainer = $SwitchMockmonBox

@onready var player_mon_hp_bar: ProgressBar = $PlayerMonHpBar
@onready var npc_mon_hp_bar: ProgressBar = $NpcMonHpBar

@onready var player_mockmon_location: Marker2D = $PlayerMockmonLocation
@onready var npc_mockmon_location: Marker2D = $NpcMockmonLocation

@onready var mockmon_card_1: Button = $SwitchMockmonBox/VBoxContainer/HBoxContainer/MockmonCard1
@onready var mockmon_card_2: Button = $SwitchMockmonBox/VBoxContainer/HBoxContainer/MockmonCard2
@onready var mockmon_card_3: Button = $SwitchMockmonBox/VBoxContainer/HBoxContainer2/MockmonCard3
@onready var mockmon_card_4: Button = $SwitchMockmonBox/VBoxContainer/HBoxContainer2/MockmonCard4
@onready var mockmon_card_5: Button = $SwitchMockmonBox/VBoxContainer/HBoxContainer3/MockmonCard5
@onready var mockmon_card_6: Button = $SwitchMockmonBox/VBoxContainer/HBoxContainer3/MockmonCard6


var turn_count = 0; ## the turn count
var battling = true;

var player_move_messages : Array[String] = []; ## messages that the game will display before a move is done.
var player_move_message_index = 0;

func _ready() -> void:
	battle_options.hide();
	switch_mockmon_box.hide();
	
	var current_player_party = player_trainer.mockmon_party;
	
	if current_player_party.size() > 0: # set the mockmon cards
		mockmon_card_1.current_mockmon = current_player_party[0];
	if current_player_party.size() > 1:
		mockmon_card_2.current_mockmon = current_player_party[1];
	if current_player_party.size() > 2:
		mockmon_card_3.current_mockmon = current_player_party[2];
	if current_player_party.size() > 3:
		mockmon_card_4.current_mockmon = current_player_party[3];
	if current_player_party.size() > 4:
		mockmon_card_5.current_mockmon = current_player_party[4];
	if current_player_party.size() > 5:
		mockmon_card_6.current_mockmon = current_player_party[5];

	
	battle(player_trainer, npc_trainer); # start battle automatically
	
	SignalBus.connect("player_done_with_battle", _end_battle_player); # connect done with battle signals
	SignalBus.connect("npc_done_with_battle", _end_battle_npc);


func battle(player: CharacterBody2D, npc: Node2D) -> void: ## starts a battle between the two characters
	player_trainer.current_mockmon.show(); # set the mockmon's locations
	npc_trainer.current_mockmon.show();
	player_trainer.current_mockmon.global_position = player_mockmon_location.global_position;
	npc_trainer.current_mockmon.global_position = npc_mockmon_location.global_position;

	while battling:
		player_mon_hp_bar.value = player_trainer.current_mockmon.currentHp;
		player_mon_hp_bar.value = player_trainer.current_mockmon.currentHp;
		
		# check which player's pokemon has the faster speed, if tied, pick random.
		if npc.current_mockmon.BASE_SPEED > player.current_mockmon.BASE_SPEED:
			npc.make_move();
			await SignalBus.npc_move_finished;
			player_make_move();
			await SignalBus.player_move_finished;
		if npc.current_mockmon.BASE_SPEED < player.current_mockmon.BASE_SPEED:
			player_make_move();
			await SignalBus.player_move_finished;
			npc.make_move();
			await SignalBus.npc_move_finished;
		else: # do randomly
			var rand_num = randi_range(1, 2);
			if rand_num == 1:
				npc.make_move();
				await SignalBus.npc_move_finished;
				player_make_move();
				await SignalBus.player_move_finished;
			else:
				player_make_move();
				await SignalBus.player_move_finished;
				npc.make_move();
				await SignalBus.npc_move_finished;
		
		turn_count += 1;

func player_make_move():
	battle_options.show();
	player_move_messages = []; ## messages that the game will display before a move is done.
	player_move_message_index = 0;
	
	
	

func player_switch_mon(mon_team_number: int) -> void: ## switch the current mon from selected mon in party.
	player_move_messages.append(player_trainer.current_mockmon + " return!");
	player_trainer.current_mockmon = player_trainer.mockmon_party[mon_team_number-1];
	player_move_messages.append("Go " + player_trainer.current_mockmon + "!");
	

func _end_battle_player() -> void: ## player lost/quit the battle
	battling = false;
	print_debug("NPC Won! in [" + turn_count + "] turns!");
	
func _end_battle_npc() -> void: ## npc lost/quit the battle
	battling = false;
	print_debug("Player Won! in [" + turn_count + "] turns!");


func _on_switch_mockmon_pressed() -> void:
	switch_mockmon_box.show();


func _on_mockmon_card_1_pressed() -> void:
	switch_mockmon_box.hide();
	player_switch_mon(1)

func _on_mockmon_card_2_pressed() -> void:
	switch_mockmon_box.hide();
	player_switch_mon(2);

func _on_mockmon_card_3_pressed() -> void:
	switch_mockmon_box.hide();
	player_switch_mon(3);

func _on_mockmon_card_4_pressed() -> void:
	switch_mockmon_box.hide();
	player_switch_mon(4);

func _on_mockmon_card_5_pressed() -> void:
	switch_mockmon_box.hide();
	player_switch_mon(5);

func _on_mockmon_card_6_pressed() -> void:
	switch_mockmon_box.hide();
	player_switch_mon(6);
