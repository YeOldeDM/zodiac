
extends Control

class BattleAction:
	var owner	# actor performing the action
	var targets = []	# array of targets of this action
	
	var action = RPG.BATTLEACTION_NULL# const from RPG.BATTLEACTION_*
	
	var nature = RPG.BATTLEACTION_HOSTILE
	
	var melee = false	# True if the attack is not ranged.
	var to_hit		# % chance the action is effective
	var damage		# effect value (damage/healing, etc)
	var status	# array of status effects inflicted on target(s)
	
	var element = null# elemental effect of this action, const RPG.ELEMENT_*
	
	var MP_cost = 0
	var speed_cost = 8	# SP cost for this action
	
	func _init(owner):
		self.owner = owner
		# All other params are set after init..

	func execute():
		randomize()
		assert self.owner
		var own = self.owner.data
		if self.action == RPG.BATTLEACTION_FIGHT:
			self.melee = own.get_weapon_range()
			self.speed_cost = 8
			# get to-hit
			var tar = self.targets[0].data
			var acc = own.get_accuracy()
			var crit = own.get_critical()
			var eva = tar.get_evade()
			self.to_hit = Roll.attack(acc, crit)
			
			# get damage
			self.damage = own.get_weapon_damage()
			
			self.targets[0].process_incoming_attack(self.to_hit, self.damage, self.melee, self.element)
			self.owner.data.current_speed -= self.speed_cost
			self.owner.draw_Spd()
			print('to hit:' +str(self.to_hit)+"  Dmg: "+str(self.damage))
			
			
			












var battler_obj = preload('res://core/battler/battler.tscn')




# Custom Signals
signal draw_round()
signal next_turn()
signal next_tick()
signal next_round()

signal victory()
signal defeat()


# Current turn/tick/round
var battle_round = -1
var battle_tick = 1
var battle_turn = 0

var battle_phase = "setup" setget _set_battle_phase

func _set_battle_phase( value ):
	battle_phase = value
	emit_signal('draw_round')

# List of all combatants
var fighters = []

# Combatants not dead or out of Speed
# Gets sorted by SPD
var active_fighters = []


var _data = null	#holder for current combat action data

var action_ready = false
var turn_over = false

onready var herobox = get_node('frame/Heroes/box')
onready var monsterbox = get_node('frame/Monsters/box')

onready var roundbox = get_node('frame/Main/box/RoundData/Values')

onready var go_timer = get_node('Go')




# INIT
func _ready():
	# Connect custom signals
	connect("draw_round",self,"_on_draw_round")
	connect("next_turn",self,"_on_next_turn")
	connect("next_tick",self,"_on_next_tick")
	connect("next_round",self,"_on_next_round")
	connect("victory",self,"_on_victory")
	connect("defeat",self,"_on_defeat")
	
	# Bootstrap Battle
	_spawn_battlers()
	go_timer.start()
	emit_signal('draw_round')



# add fighters to the fight
func _spawn_battlers():
	add_hero('Fess')
	add_monster('Rat')

# pre-battle management
func _pre_battle():	
	_assemble_fighter_list()
	_set_active_fighters()
	_sort_active_fighters(true)
	print(active_fighters)
	battle_round = 0
	emit_signal("draw_round")
	go_timer.start()

# Compile hero and monster lists into master fighters list
func _assemble_fighter_list():
	for child in get_heroes():
		fighters.append(child)
	for child in get_monsters():
		fighters.append(child)

# Clears and repopulates active fighters list
func _set_active_fighters():
	active_fighters = []
	print(fighters)
	for child in fighters:
		print(child.data.name)
		# if not dead..
		if !child.data.has_status_effect(RPG.STATUS_DEATH):
			# if we have sufficient SPD for an action..
			if child.data.current_speed >= 8:
				active_fighters.append(child)
		
func _clean_active_fighters():
	for child in active_fighters:
		var passed = true
		if child.data.has_status_effect(RPG.STATUS_DEATH):
			passed = false
		if child.data.current_speed < 8:
			passed = false
		if not passed:
			active_fighters.remove(active_fighters.find(child))

# Sort active fighters list by current SP
func _sort_active_fighters(first_round=false):
	for fighter in active_fighters:
		fighter.data.refresh_speed(first_round)
	active_fighters.sort_custom(self, '_sort_by_speed')
	set('battle_phase', "rolling initiative")
# custom sort function for _sort_active_fighters
func _sort_by_speed(a,b):
	if a.data.current_speed > b.data.current_speed:
		return true
	return false

# Custom Signal Functions

# Signal Draw Round (info)
func _on_draw_round():
	roundbox.get_node('Round').set_text(str(battle_round))
	roundbox.get_node('Tick').set_text(str(battle_tick))
	roundbox.get_node('Turn').set_text(str(battle_turn))
	if _data:
		roundbox.get_node('Who').set_text(_data.owner.data.name)
	else:
		roundbox.get_node('Who').set_text("-Nil-")
	
	roundbox.get_node('Phase').set_text(battle_phase)



# Signal Next Turn
func _on_next_turn():
	_check_for_victory()
	_clean_active_fighters()
	battle_turn += 1
	if battle_turn > active_fighters.size()-1:
		emit_signal("next_tick")
	_data = BattleAction.new(fighters[battle_turn])
	set('battle_phase', "Pending action for "+_data.owner.data.name)
	emit_signal('draw_round')
	if !_data.owner.data.has_status_effect(RPG.STATUS_DEATH):
		get_node('ActionDialog').popup_centered()
	else:
		emit_signal('next_turn')

# Signal Next Tick
func _on_next_tick():
	_set_active_fighters()
	_sort_active_fighters()
	set('battle_phase', "sorting initiative order")
	battle_turn = 0
	battle_tick += 1
	if active_fighters.empty():
		emit_signal("next_round")
	emit_signal('draw_round')
	
# Signal Next Round
func _on_next_round():
	battle_turn = 0
	battle_tick = 1
	battle_round += 1
	emit_signal('draw_round')
	emit_signal('next_turn')



func _check_for_victory():
	var hero_vic = true
	var mob_vic = true
	for hero in get_heroes():
		if !hero.data.has_status_effect(RPG.STATUS_DEATH):
			mob_vic = false
	for mob in get_monsters():
		if !mob.data.has_status_effect(RPG.STATUS_DEATH):
			hero_vic = false
	
	if hero_vic:	emit_signal('victory')
	elif mob_vic:	emit_signal('defeat')


# Signal on Victory
func _on_victory():
	OS.alert("The Heroes are victorious!")

# Signal on Defeat
func _on_defeat():
	OS.alert("The Heroes have been defeated!")



# On battle GO timer times out
func _on_Go_timeout():
	if battle_round < 0:
		_pre_battle()
		emit_signal("next_round")
	
	if turn_over:
		turn_over = false
		emit_signal("next_turn")
	
	if action_ready:
		resolve_battle_action()
		action_ready = false
		turn_over = true
		go_timer.start()





# PUBLIC FUNCTIONS #

# Get list of Hero battlers
func get_heroes():
	return herobox.get_children()

# Get list of Monster battlers
func get_monsters():
	return monsterbox.get_children()


# Add Battler objects and set them to data
func add_hero(name):
	var obj = battler_obj.instance()
	herobox.add_child(obj)
	obj.set_hero(name)

func add_monster(name):
	var obj = battler_obj.instance()
	monsterbox.add_child(obj)
	obj.set_monster(name)

# Execute a BattleAction, once actions/targets/etc
# are defined
func resolve_battle_action():
	assert _data.owner
	#assert _data.nature
	assert _data.action >= 0
	assert _data.targets.size()>0
	_data.execute()


