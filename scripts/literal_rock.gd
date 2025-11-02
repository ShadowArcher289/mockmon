extends Node2D

var rock_slam = move.new("Rock Slam", "Rock", 40, "Physical", 15, 100);
var intimidating_stare = move.new("Intimidating Stare", "Psychic", 10, "Special", 20, 100);
var rock_throw = move.new("Rock Throw", "Rock", 60, "Physical", 15, 90);
var what_rocks_do = move.new("What Rocks Do", "Rock", 0, "Physical", 30, 80);

const TYPE : Array[String] = ["Rock"];

const MOCKMON_NAME = "Literal Rock";
const MOCKMON_SPRITE = preload("res://sprites/ALiteralRock.png");

const MAX_HP = 120; # base sats
const BASE_ATK = 10;
const BASE_DEF = 20;
const BASE_SPEC_ATK = 30;
const BASE_SPEC_DEF = 30;
const BASE_SPEED = 50;

const WEAKNESSES: Array[String] = ["Water", "Ground", "Grass", "Fighting", "Steel"];
const RESISTANCES: Array[String] = ["Normal", "Flying", "Poison", "Fire"];
const IMMUNITIES: Array[String] = [];

var moves: Array[move];

var currentHp = MAX_HP;
var death : bool

func _ready() -> void:
	moves = [rock_slam, intimidating_stare, rock_throw, what_rocks_do];

func use_move(move_choice: move, target: Node2D): ## Use a move on a given target given a move 
	if target.has_method("take_damage"):
		if move_choice.is_category("special"):
			target.take_damage(BASE_SPEC_ATK, move_choice);
		elif move_choice.is_category("physical"):
			target.take_damage(BASE_ATK, move_choice);


func get_move(move_number: int): ## Returns the mockmon's move
	return moves[move_number-1];

func take_damage(enemy_atk: int, move_used: move): ## The Mockmon takes damage
	var damage = 0;
	if move_used.is_category("special"):
		damage = Globals.calculate_damage(enemy_atk, BASE_SPEC_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES);
	elif move_used.is_category("physical"):
		damage = Globals.calculate_damage(enemy_atk, BASE_DEF, move_used.power, move_used.type, WEAKNESSES, RESISTANCES, IMMUNITIES);
	
	currentHp -= damage;
	
	if currentHp <= 0:
		death = true;
