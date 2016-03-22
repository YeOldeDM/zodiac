
extends Node

class Guard:
	var name
	var level
	
	var abilities
	
	func _init(name='shield',level=1,abilities=[]):
		self.name = name
		self.level = level
		self.abilities = abilities
	
	func get_evade():
		return Chart.guard_chart[self.level-1]
