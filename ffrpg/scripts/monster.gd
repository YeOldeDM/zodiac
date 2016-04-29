
extends Node

class Monster:
	var name
	var level
	var boss
	
	var base_strength
	var base_magic
	var base_vitality
	var base_spirit
	var base_agility
	
	var max_HP
	var max_MP
	var current_HP
	var current_MP
	var current_speed=0
	
	var power_die
	var magic_die
	
	var XP = 0
	var GP = 0
	
	var is_blocking = false
	var is_flying = false
	
	func _init(name="New Monster",level=1,boss=false,\
	strength=6,magic=6,vitality=6,spirit=6,agility=6,\
	power_die=8,magic_die=8):
		self.name = name
		self.level = level
		self.boss = boss
		self.base_strength = strength
		self.base_magic = magic
		self.base_vitality = vitality
		self.base_spirit = spirit
		self.base_agility = agility
		
		self.power_die = power_die
		self.magic_die = magic_die
		
		self.max_HP = self.calculate_HP()
		self.max_MP = self.calculate_MP()
		self.XP = self.calculate_XP()
		self.GP = self.calculate_GP()

	func get_package():
		var data = {}
		data['monster'] = inst2dict(self)
		return data

	func restore_full():
		self.restore_HP()
		self.restore_MP()
		
	func restore_HP():
		self.current_HP = self.get_HP()
	func restore_MP():
		self.current_MP = self.get_MP()
	
	func restore_speed():
		self.current_speed += self.get_speed()
	
	func set_initial_speed():
		var S = get_speed()
		var R = int(round(rand_range(1,8)))
		self.current_speed = S+R
	
	func get_name():
		return self.name
	
	func set_name(name):
		self.name = name
	
	func get_level():
		return self.level
	
	func set_level(value):
		self.level = value
	
	func is_boss():
		return self.boss
	func set_boss(value):
		self.boss = value
	
	func get_total_stats():
		return 25 + (self.get_level()*5)
	
	func get_tech():
		return 1 + int(self.get_magic()/5)
	
	func get_strength():
		return self.base_strength
	func set_strength(value):
		self.base_strength = value
		
	func get_magic():
		return self.base_magic
	func set_magic(value):
		self.base_magic = value

	func get_vitality():
		return self.base_vitality
	func set_vitality(value):
		self.base_vitality = value

	func get_spirit():
		return self.base_spirit
	func set_spirit(value):
		self.base_spirit = value

	func get_agility():
		return self.base_agility
	func set_agility(value):
		self.base_agility = value
	
	func get_XP():
		return self.XP

	func calculate_XP():
		if self.is_boss():
			return self.get_level()*150
		else:
			return self.get_level()*35
	
	func get_GP():
		return self.GP

	func calculate_GP():
		if self.is_boss():
			return self.get_level()*75
		else:
			return self.get_level()*15
	
	func get_HP():
		return self.max_HP
	func calculate_HP():
		var vit_bonus = self.get_vitality() * 20
		var lvl_bonus = self.get_level() * 10
		var total = 30 + vit_bonus + lvl_bonus
		if self.is_boss():
			total *= 10
		return total
	
	func get_MP():
		return self.max_MP
	func calculate_MP():
		var base = self.get_spirit() + self.get_level()
		var total = int(base/2)
		if self.is_boss():
			total *= 2
		return total
	
	func spend_speed(amt=8):
		self.current_speed -= amt
		if self.current_speed <= 0:
			self.current_speed = 0
		print(self.get_name()+" spent speed "+str(amt))

	func get_attack_power():
		return self.get_strength() * 2
	
	func get_magic_attack_power():
		return self.get_magic() * 2

	func get_strength_dice():
		var dice = floor(self.get_strength() / 100)
		return dice+1
	
	func get_magic_dice():
		var dice = floor(self.get_magic() / 100)
		return dice+1
	
	func get_accuracy():
		var agi_bonus = floor(self.get_agility() / 5)
		return 5 + agi_bonus
	
	func get_magic_accuracy():
		var mag_bonus = floor(self.get_magic() / 5)
		return 5 + mag_bonus
	
	func get_evade():
		var agi_bonus = floor(self.get_agility() / 5)
		return 25 + agi_bonus
	
	func get_resist():
		var vit_bonus = floor(self.get_vitality() / 10)
		var spr_bonus = floor(self.get_spirit() / 10)
		return 25 + vit_bonus + spr_bonus
	
	func get_critical():
		var agi_bonus = floor(self.get_agility() / 15)
		return 98 - agi_bonus
	
	func get_speed():
		var agi_bonus = floor(self.get_agility() / 15)
		var lvl_bonus = floor(self.get_level() / 10)
		return 10 + agi_bonus + lvl_bonus
	
	func fight(target):
		#assembles attack information and returns it as a list
		#[damage dealt, bool attack hits, bool attack auto-hits, bool is critical]
		var attack = Roll.attack(self.get_accuracy(),target.get_evade(),self.get_critical())
		var crit_mult = 2	#placeholder. Can be higher or set to 1 for critical-immunity
		var damage = Roll.damage(self.get_strength_dice(),self.power_die,self.get_attack_power(),\
								attack[2],crit_mult)
		attack.insert(0,damage)	#stick damage in as the first value in the list
		return attack
	
	func receive_attack(attack):
		if attack[1] or attack[2]:
			var damage = attack[0]
			if is_blocking:
				damage /= 2
			current_HP -= damage
			if current_HP <= 0:
				current_HP = 0
	
	
	
