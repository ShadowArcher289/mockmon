extends Node2D

var pocket_knife = move.new("Steel", 100000000, "Physical", 5, 20);
var alley_jump = move.new("Dark", 50, "Physical", 15, 100);
var pickpocket = move.new("Normal", 80, "Physical", 10, 95);
var flash = move.new("Psychic", 100, "Special", 10, 80);

const TYPE : Array[String] = ["Normal", "Dark"];

const MAX_HP = 80; # base sats
const BASE_ATK = 80;
const BASE_DEF = 110;
const BASE_SPEC_ATK = 40;
const BASE_SPEC_DEF = 120;
const BASE_SPEED = 20;

const WEAKNESSES: Array[String] = ["Water", "Ground", "Grass", "Fighting", "Steel"];
const RESISTANCES: Array[String] = ["Normal", "Flying", "Poison", "Fire"];
const IMMUNITIES: Array[String] = [];

var currentHp = MAX_HP;
