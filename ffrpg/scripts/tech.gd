
extends Node

class Tech:
	var owner
	var name
	
	var level
	var power_level	#0=weak,1=normal,2=strong
	
	var effect
	
	func _init(owner,name,level,power_level,effect):
		self.owner = owner
		self.name = name
		self.level = level
		self.power_level = power_level
		
		self.effect = effect

	
	func get_name():
		return self.name
	
	func set_name(name):
		self.name = name




class AttackMagic:
	var tech
	var secondary = []
	
	func _init(tech,secondary=[]):
		self.tech = tech
		self.secondary = secondary
	
	func get_MP_adjustment():
		var adj = 0
		for sec in secondary:
			adj += sec.MP_adjustment

class AreaEffect:
	var effect
	var MP_adjustment
	
	func _init(effect,adjustment):
		self.effect = effect
		self.MP_adjustment = adjustment
