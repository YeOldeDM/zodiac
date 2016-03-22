
extends Node


class Armor:
	var name
	var level
	
	var armor_class
	
	var abilities
	
	func _init(name='mail',level=1,armor_class=2,abilities=[]):
		self.name = name
		self.level = level
		self.armor_class = armor_class
		self.abilities = abilities
	
	func get_HP():
		return Chart.armor_chart[self.armor_class][self.level-1][0]
	
	func get_MP():
		return Chart.armor_chart[self.armor_class][self.level-1][1]
	


