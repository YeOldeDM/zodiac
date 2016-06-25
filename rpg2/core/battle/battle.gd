
extends Control

class BattleAction:
	var owner	# actor performing the action
	var targets	# array of targets of this action
	
	var action	# const from RPG.BATTLEACTION_*
	

	var to_hit		# % chance the action is effective
	var damage		# effect value (damage/healing, etc)
	var status		# array of status effects inflicted on target(s)
	
	var elements	# array of elemental effects of this action, const from RPG.ELEMENT_*
	
	var speed_cost	# SP cost for this action
	
	func _init(owner):
		self.owner = owner
		# All other params are set after init..

	func execute():
		pass

# Custom Signals
signal draw_round()
signal next_turn()
signal next_tick()
signal next_round()

signal victory()
signal defeat()


# Current turn/tick/round
var battle_round = 0
var battle_tick = 1
var battle_turn = 0

# List of all combatants
var fighters = []

# Combatants not dead or out of Speed
var active_fighters = []

# Current tick's active combatants in order of Spd
var ordered_fighters = []

var _data = {}	#holder for current combat action data





func _ready():
	# Connect custom signals
	connect("draw_round",self,"_on_draw_round")
	connect("next_turn",self,"_on_next_turn")
	connect("next_tick",self,"_on_next_tick")
	connect("next_round",self,"_on_next_round")
	connect("victory",self,"_on_victory")
	connect("defeat",self,"_on_defeat")




# Custom Signal Functions
func _on_draw_round():
	pass
	
func _on_next_turn():
	battle_turn += 1
	if battle_turn > active_fighters.size():
		emit_signal("next_tick")
	_data = BattleAction.new(fighters[battle_turn])
	emit_signal('draw_round')

func _on_next_tick():
	battle_turn = 0
	battle_tick += 1
	if active_fighters.empty():
		emit_signal("next_round")
	emit_signal('draw_round')
	

func _on_next_round():
	battle_turn = 0
	battle_tick = 1
	battle_round += 1

func _on_victory():
	pass

func _on_defeat():
	pass


# PUBLIC FUNCTIONS #

func get_party():
	# Returns a list of all Hero battlers
	pass


func get_monsters():
	# Returns a list of all Monster battlers
	pass


