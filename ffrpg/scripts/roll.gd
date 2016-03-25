
extends Node


func die(sides):	#roll 1d'sides'
	return int(round(rand_range(1,sides)))

func dice(num,sides):	#roll 'num'd'sides'
	var total = 0
	for i in range(num):
		total += die(sides)
	return total

func attack(atk,def,crit_chance):
	var critical_hit = false
	var auto_hit = false
	var hit = false
	
	var R = die(100)
	if R >= 90:
		auto_hit = true
	if R >= 100-crit_chance:
		critical_hit = true
	if R+atk >= def:
		hit = true
	return [hit,auto_hit,critical_hit]

func damage(num,sides,atk,critical,critical_mult=2):
	var base = dice(num,sides)
	var total = base + atk
	if critical:
		total *= critical_mult
	return total

func initiative(actors):
	#sort list by Speed Stat
	actors.sort_custom(self,"_sort_by_speed")

func _sort_by_speed(a,b):
	if a.me.current_speed > b.me.current_speed:
		return true
	else:
		return false