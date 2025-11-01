extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var npc_trainer: Node2D = $NpcTrainer

func _ready() -> void:
	battle(player, npc_trainer);

func battle(player: CharacterBody2D, npc: Node2D) -> void: ## starts a battle between the two characters
	pass;
	
	
