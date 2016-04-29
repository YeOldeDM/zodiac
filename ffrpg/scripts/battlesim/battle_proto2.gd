
extends Container

#signals
signal draw_round()
signal next_turn()
signal next_tick()
signal next_round()

#message broadcaster node
onready var msg = get_node('/root/Battle/box/battle/message/msgbox')

#child nodes
onready var heroes = get_node('box/heroes')
onready var monsters = get_node('box/battle/monsters/box/list')
onready var combat = get_node('box/options/actions/combat')

onready var round_label = get_node('box/options/meta/box/round/value')

#current round in the battle
var combat_round = 1

#current tick in the round
var tick = 1

#current turn in the initiative stack
var current_turn = 0

#list of all actors
var actors = []

#list of active actors: alive and have >= 8 spd points
var fighters = []

#dictionary of combat data. Refreshed every turn
var _data = {}

var current_fighter

var current_action
var current_action_target

func _ready():
	#connect signals
	connect("draw_round",self,"_on_draw_round")
	connect("next_turn",self,"_on_next_turn")
	connect("next_tick",self,"_on_next_tick")
	connect("next_round",self,"_on_next_round")
	#build actorr/fighters lists
	actors = get_actors()
	fighters = actors
	
	roll_initiative()

#return a list of all heroes
func get_heroes():
	return heroes.get_children()

#return a list of all monsters
func get_monsters():
	return monsters.get_children()

#return a list of all actors - hero and monster
func get_actors():
	var ActorList = []
	for actor in heroes.get_children():
		ActorList.append(actor)
	for actor in monsters.get_children():
		ActorList.append(actor)
	return ActorList

func is_hero(actor):
	if actor.me.has_method('get_xp_to_level'):
		return true
	return false

func roll_initiative():
	#sort list by Speed
	Roll.initiative(fighters)
	msg.say("\n[color=red]Round[/color] "+str(combat_round))

func pre_battle():
	current_turn = 0
	combat_round = 1
	current_tick = 1
	for actor in fighters:
		#set initial Speed values (SPD stat+1d8)
		actor.me.set_initial_speed()
		#draw battler info to screen
		actor.draw_battler()
	#create order of initiative for the round
	roll_initiative()
	_data['attacker'] = fighters[current_turn]
	#current_fighter = fighters[current_turn]
	_data['attacker'].activate_battler()
	if !is_hero(_data['attacker']):
		monster_action()
	else:
		show_combat_options()


func monster_action():
	_data['attacker'].monster_pre_action()
	pass

func monster_post_action():
	msg.say("The "+_data['attacker'].get_name()+" does a little dance!")
	emit_signal("next_turn")

func show_combat_options():
	pass

func _on_draw_round():
	var text = "Round "+str(combat_round)+"/"+str(tick)+"/"+str(current_turn)
	round_label.set_text(text)
	
func _on_next_turn():
	current_turn += 1
	if current_turn > fighters.size():
		emit_signal("next_tick")
	_data = {}
	_data['attacker'] = fighters[current_turn]
	emit_signal('draw_round')

func _on_next_tick():
	current_turn = 0
	tick += 1
	if fighters.empty():
		emit_signal("next_round")
	emit_signal('draw_round')
	

func _on_next_round():
	current_turn = 0
	tick = 1
	current_round += 1
	