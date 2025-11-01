extends Node

const LEVEL = 50.0;

func calculate_damage(enemy_atk: float, my_defense: float, move_power: float) -> int:
		return ceili( ( ((((2.0*LEVEL)/5)+2) * move_power * (enemy_atk/my_defense)) /50.0) + 2);
