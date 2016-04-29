
extends Node

class Actor:
	var name
	
	var level
	
	var base_strength
	var base_magic
	var base_vitality
	var base_spirit
	var base_agility
	
	var current_HP
	var current_MP
	var current_speed
	
	var is_blocking = false
	
	var role
	
	func _init(role,name="Actor",level=1,\
				strength=8,magic=8,vitality=8,spirit=8,agility=8):
		self.name = name
		self.level = level
		self.base_strength = strength
		self.base_magic = magic
		self.base_vitality = vitality
		self.base_spirit = spirit
		self.base_agility = agility

		self.role = role
		assert(role != null)
		
		if role:
			role.owner = self
	
	func get_name():
		return self.name
	
	func set_name(text):
		self.name = text
	
	func get_level():
		return self.level
	
	func set_level(n):
		self.level = n

