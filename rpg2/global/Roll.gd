
extends Node

# Functions for various dice rolls




# basic die roll, between Low and High numbers
func die( L, H ):
	return int(round(rand_range(L,H)))

# roll standard 1dx dice
func dice( dice, sides ):
	var result = 0
	for i in range(dice):
		result += die(1,sides)
	return result


# returns a true randi of 
# traditional dice rolls x10
# [  {10-100} vs {(1-10)*10} ]
func damage( dice, sides ):
	var result = 0
	for i in range(dice):
		result += die(10, sides * 10)
	return result


# Returns Dictionary: raw d100 roll, 
# modified attack roll,
# flag auto-hit, flag critical hit 
func attack( accuracy, critical_chance ):
	#clamp crit% to 0-100
	critical_chance = clamp(critical_chance,0,100)
	
	var autohit = false
	var critical = false
	# roll 1d100..
	var roll = die(1,100)
	# adjust for accuracy..
	var adjusted_roll = roll+accuracy

	# automatically hits if roll is 90%+
	if roll >= 90:	autohit = true
	# hit is critical if higher than critical_chance
	if adjusted_roll >= 100-critical_chance:
		critical = true
	
	return {'d100':roll,
			'roll':adjusted_roll,
			'is_autohit':autohit,
			'is_critical':critical}
