extends Control

@onready var player_trainer: CharacterBody2D = $Player
@onready var npc_trainer: Node2D = $NpcTrainer

@onready var battle_options: HBoxContainer = $UiBody/BattleOptions
@onready var attack_options: MarginContainer = $UiBody/Node2D/AttackOptions
@onready var switch_mockmon_box: MarginContainer = $UiBody/SwitchMockmonBox

@onready var player_mon_hp_bar: ProgressBar = $UiBody/PlayerMonHpBar
@onready var npc_mon_hp_bar: ProgressBar = $UiBody/NpcMonHpBar

@onready var player_mockmon_location: Marker2D = $PlayerMockmonLocation
@onready var npc_mockmon_location: Marker2D = $NpcMockmonLocation

@onready var mockmon_card_1: Button = $UiBody/SwitchMockmonBox/VBoxContainer/HBoxContainer/MockmonCard1
@onready var mockmon_card_2: Button = $UiBody/SwitchMockmonBox/VBoxContainer/HBoxContainer/MockmonCard2
@onready var mockmon_card_3: Button = $UiBody/SwitchMockmonBox/VBoxContainer/HBoxContainer2/MockmonCard3
@onready var mockmon_card_4: Button = $UiBody/SwitchMockmonBox/VBoxContainer/HBoxContainer2/MockmonCard4
@onready var mockmon_card_5: Button = $UiBody/SwitchMockmonBox/VBoxContainer/HBoxContainer3/MockmonCard5
@onready var mockmon_card_6: Button = $UiBody/SwitchMockmonBox/VBoxContainer/HBoxContainer3/MockmonCard6

@onready var move_card_1: TextureButton = $UiBody/Node2D/AttackOptions/VBoxContainer/HBoxContainer/MoveCard1
@onready var move_card_2: TextureButton = $UiBody/Node2D/AttackOptions/VBoxContainer/HBoxContainer/MoveCard2
@onready var move_card_3: TextureButton = $UiBody/Node2D/AttackOptions/VBoxContainer/HBoxContainer2/MoveCard3
@onready var move_card_4: TextureButton = $UiBody/Node2D/AttackOptions/VBoxContainer/HBoxContainer2/MoveCard4

@onready var dialog_label: RichTextLabel = $UiBody/BattleOptions/MarginContainer/DialogLabel

@onready var npc_move_finished_timer: Timer = $NpcMoveFinishedTimer
@onready var player_move_finished_timer: Timer = $PlayerMoveFinishedTimer
@onready var turn_counter_label: Label = $UiBody/TurnCounterLabel


var turn_count = 0; ## the turn count
var battling = true;

var player_move_messages : Array[String] = []; ## messages that the game will display before a move is done.
var player_move_message_index = 0;


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_dialog"):
		next_dialog();

func next_dialog(): ## progress to the next dialog if one is available
	if player_move_messages.size() != 0: # removes and returns the first message in player_move_messages
			dialog_label.text = player_move_messages.pop_front();
			print(dialog_label.text + " | turn: " + str(turn_count));


func _ready() -> void:
	
	SignalBus.connect("player_done_with_battle", _end_battle_player); # connect done with battle signals
	SignalBus.connect("npc_done_with_battle", _end_battle_npc);
	SignalBus.connect("npc_move_finished", _npc_move_finished); # connect npc move_finished signal
	SignalBus.connect("player_move_finished", _player_move_finished);
	
	battle_options.show();
	attack_options.hide();
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
	
	move_card_1.current_move = player_trainer.current_mockmon.moves[0]; # set the mockmon's move options
	move_card_2.current_move = player_trainer.current_mockmon.moves[1];
	move_card_3.current_move = player_trainer.current_mockmon.moves[2];
	move_card_4.current_move = player_trainer.current_mockmon.moves[3];
	
	battle(player_trainer, npc_trainer); # start battle automatically

func _process(_delta: float) -> void:
	if player_trainer.current_mockmon.death && !switch_mockmon_box.is_visible_in_tree(): # prompt to switch mon if the current is dead.
		switch_mockmon_box.show();
		await player_move_finished_timer.timeout;
		
	for mon in npc_trainer.mockmon_party: # loop through every npc mon, if it is not the current, and it is not hidden, hide it.
		if mon != npc_trainer.current_mockmon && mon.is_visible_in_tree():
			mon.hide();

func battle(player: CharacterBody2D, npc: Node2D) -> void: ## starts a battle between the two characters
	player_trainer.current_mockmon.show(); # set the mockmon's locations
	npc_trainer.current_mockmon.show();
	player_trainer.current_mockmon.global_position = player_mockmon_location.global_position;
	npc_trainer.current_mockmon.global_position = npc_mockmon_location.global_position;

	while battling: # every round, battle cycle
		player_trainer.current_mockmon.show(); # set the mockmon's locations
		npc_trainer.current_mockmon.show();
		player_trainer.current_mockmon.global_position = player_mockmon_location.global_position;
		npc_trainer.current_mockmon.global_position = npc_mockmon_location.global_position;
	
		update_hp_bars();

		# check which player's pokemon has the faster speed, if tied, pick random.
		if npc.current_mockmon.BASE_SPEED > player.current_mockmon.BASE_SPEED:
			npc.make_move(player_trainer.current_mockmon);
			await npc_move_finished_timer.timeout;
			player_make_move();
			await player_move_finished_timer.timeout;
		elif npc.current_mockmon.BASE_SPEED < player.current_mockmon.BASE_SPEED:
			player_make_move();
			await player_move_finished_timer.timeout;
			npc.make_move(player_trainer.current_mockmon);
			await npc_move_finished_timer.timeout;
		else: # do randomly
			var rand_num = randi_range(1, 2);
			if rand_num == 1:
				npc.make_move(player_trainer.current_mockmon);
				await npc_move_finished_timer.timeout;
				player_make_move();
				await player_move_finished_timer.timeout;
			else:
				player_make_move();
				await player_move_finished_timer.timeout;
				npc.make_move(player_trainer.current_mockmon);
				await npc_move_finished_timer.timeout;
		
		turn_count += 1;
		turn_counter_label.text = "Turn: " + str(turn_count);


func player_make_move():
	battle_options.show();
	#player_move_messages = []; ## messages that the game will display before a move is done.
	#player_move_message_index = 0;

func player_switch_mon(mon_team_number: int) -> void: ## switch the current mon from selected mon in party.
	if mon_team_number <= player_trainer.mockmon_party.size(): # only run if the inputted team number is valid given the team size
		player_move_messages.append(player_trainer.current_mockmon.MOCKMON_NAME + " return!");
		next_dialog();
		player_trainer.current_mockmon.hide();
		player_trainer.current_mockmon = player_trainer.mockmon_party[mon_team_number-1];
		player_move_messages.append("Go " + player_trainer.current_mockmon.MOCKMON_NAME + "!");
		next_dialog();
		player_trainer.current_mockmon.show(); # set the mockmon's locations
		player_trainer.current_mockmon.global_position = player_mockmon_location.global_position;
		update_moves();
		update_hp_bars();
		SignalBus.player_move_finished.emit();

func player_mon_atk(move_number: int, target: Node2D):
	var used_move = player_trainer.current_mockmon.get_move(move_number);
	player_move_messages.append(player_trainer.current_mockmon.MOCKMON_NAME + " used " + used_move.move_name + "!");
	next_dialog();
	player_trainer.current_mockmon.use_move(used_move, target);
	attack_options.hide();
	
	update_hp_bars();
		
	SignalBus.player_move_finished.emit();
	

func update_hp_bars() -> void: ## update hp bars
	player_mon_hp_bar.max_value = player_trainer.current_mockmon.MAX_HP; # set hp bar max values
	npc_mon_hp_bar.max_value = npc_trainer.current_mockmon.MAX_HP;
	player_mon_hp_bar.value = player_trainer.current_mockmon.currentHp; # set hp bar values
	npc_mon_hp_bar.value = npc_trainer.current_mockmon.currentHp;

func update_moves():
	move_card_1.current_move = player_trainer.current_mockmon.moves[0]; # set the mockmon's move options
	move_card_2.current_move = player_trainer.current_mockmon.moves[1];
	move_card_3.current_move = player_trainer.current_mockmon.moves[2];
	move_card_4.current_move = player_trainer.current_mockmon.moves[3];
	
func _end_battle_player() -> void: ## player lost/quit the battle
	battling = false;
	print_debug("NPC Won! in [" + turn_count + "] turns!");
	
func _end_battle_npc() -> void: ## npc lost/quit the battle
	battling = false;
	print_debug("Player Won! in [" + turn_count + "] turns!");

func _npc_move_finished(move_description: String):
	npc_move_finished_timer.start(); # start the timer to progress through the battle's awaits
	if move_description != null:
		player_move_messages.append(move_description);
		next_dialog();

	update_hp_bars();
	update_moves();
	npc_trainer.current_mockmon.show(); # set the mockmon's locations
	npc_trainer.current_mockmon.global_position = npc_mockmon_location.global_position;

func _player_move_finished():
	player_move_finished_timer.start();

func _on_fight_pressed() -> void:
	attack_options.show();

func _on_switch_mockmon_pressed() -> void:
	switch_mockmon_box.show();

 # Switch Mockmon Buttons
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

 # Hide Battle UI Submenues
func _on_hide_switch_mockmon_pressed() -> void:
	switch_mockmon_box.hide();

func _on_hide_attack_options_pressed() -> void:
	attack_options.hide();

 # Attack with Mockmon Buttons
func _on_move_card_1_pressed() -> void:
	player_mon_atk(1, npc_trainer.current_mockmon);

func _on_move_card_2_pressed() -> void:
	player_mon_atk(2, npc_trainer.current_mockmon);

func _on_move_card_3_pressed() -> void:
	player_mon_atk(3, npc_trainer.current_mockmon);

func _on_move_card_4_pressed() -> void:
	player_mon_atk(4, npc_trainer.current_mockmon);
