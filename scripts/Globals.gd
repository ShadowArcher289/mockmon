extends Node

const LEVEL = 50.0;

func calculate_damage(enemy_atk: float, my_defense: float, move_power: float, move_type: String, weaknesses: Array[String], resistances: Array[String], immunities: Array[String]) -> int:
	var type_modifier = weak_calc(move_type, weaknesses, resistances, immunities);
	return ceili( ( ((((2.0*LEVEL)/5)+2) * move_power * (enemy_atk/my_defense)) /50.0) + 2) * type_modifier;
	
func weak_calc(moveType: String, weaknesses: Array[String], resistances: Array[String], immunities:Array[String]) -> float:
	var count:int = 0
	if(immunities.has(moveType)) :
		return 0
	for i in range(weaknesses.size()) :
		if weaknesses[i] == moveType:
			count+=1
	for i in range(resistances.size()) :
		if resistances[i] == moveType:
			count -=1
	if count == 1 :
		return 2
	elif count == 2:
		return 4
	elif count == -1:
		return 0.5
	elif count <= -2 :
		return 0.25
	else:
		return 1

func is_weak(moveType: String, mon: Mockmon) -> bool: 
	var count:int = 0
	for i in range(mon.weaknesses.size()) :
		if mon.weaknesses[i] == moveType:
			count+=1
	for i in range(mon.resistances.size()) :
		if mon.resistances[i] == moveType:
			count -=1
	if count > 0 :
		return true
	if count <= 0 :
		return false
	return false

func is_resist(moveType: String, mon: Mockmon) -> bool: 
		var count: int = 0
		for i in range(mon.resistances.size()) :
			if mon.resistances[i] == moveType :
				count +=1
		for i in range(mon.weaknesses.size()) :
			if mon.resistances[i] == moveType :
				count -=1
		if count > 0 :
			return true
		if count <= 0 :
			return false
		return false;
		
func is_neutral(moveType: String, mon : Mockmon) -> bool: 
		var count: int = 0
		for i in range(mon.resistances.size()) :
			if mon.resistances[i] == moveType :
				count +=1
		for i in range(mon.weaknesses.size()) :
			if mon.resistances[i] == moveType :
				count -=1
		if count == 0 :
			return true
		else :
			return false
