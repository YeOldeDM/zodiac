
extends Node


class Weapon:
	var name
	var level
	
	var attack_points
	var magic_points

	var abilities

	func _init(name="sword",level=1,attack=5,magic=1,abilities=[]):
		self.name = name
		self.level = level
		self.attack_points = attack
		self.magic_points = magic
		self.abilities = abilities
	
	func get_attack_power():
		return Chart.weapon_attack_chart[self.level-1][self.attack_points-1]
	
	func get_magic_power():
		return Chart.weapon_attack_chart[self.level-1][self.magic_points-1]
	
	func get_attack_die(mod=0):
		var index = clamp(mod+(self.attack_points-1),0,4)
		return Chart.weapon_attack_dice[index]

	func get_magic_die(mod=0):
		var index = clamp(mod+(self.magic_points-1),0,4)
		return Chart.weapon_attack_dice[index]
	
	#should be depricated
	func get_damage_roll(dice,power=0):
		var sides = Chart.weapon_attack_dice[self.attack_points-1]
		sides += power*2
		var roll = 0
		for i in range(dice):
			roll += int(round(rand_range(1,sides))) * 10
		return roll
	
	func get_magic_damage_roll(dice,power=0):
		var sides = Chart.weapon_attack_dice[self.magic_points-1]
		sides += power*2
		var roll = 0
		for i in range(dice):
			roll += int(round(rand_range(1,sides))) * 10
		return roll
