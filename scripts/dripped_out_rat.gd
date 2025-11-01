extends Node2D
var fling_drip = move.new("Steel", 40, "Physical", 10, 90);
var sick_burn = move.new("Fire", 30, "Special", 20, 100);
#var fling_drip = move.new("Steel", 40, "Physical", 10, 90);
#var fling_drip = move.new("Steel", 40, "Physical", 10, 90);

var moves: Array[move] = [];

const MAX_HP = 120; # base sats
const BASE_ATK = 10;
const BASE_DEF = 20;
const BASE_SPEC_ATK = 30;
const BASE_SPEC_DEF = 30;
const BASE_SPEED = 50;

var currentHp = MAX_HP;

func _ready() -> void:
	moves = [fling_drip, sick_burn];

func use_move(move_number: int, target: Node2D): ## Use a move on a given target given the move number
	if target.has_method("take_damage"):
		target.take_damage(moves[move_number-1]);

func get_move(move_number: int): ## Returns the mockmon's move
	return moves[move_number-1];

func take_damage(move_used: move):
	
