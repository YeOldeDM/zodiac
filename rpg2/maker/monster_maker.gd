
extends PanelContainer

onready var stats_box = get_node('box/stats')
onready var info = stats_box.get_node('info')
onready var stats = stats_box.get_node('stats')
onready var powers = stats_box.get_node('powers/box')

onready var stat_editors = stats.get_node('values')
onready var ex_stat_editors = stats.get_node('ex_values')
onready var stat_total = stats.get_node('total')

onready var ex_stats_editor = powers.get_node('ExceptionalStats/Value')

onready var elements_editors = powers.get_node('Elements/Values')

onready var flight_editor = powers.get_node('Flight/Value')
onready var agile_editor = powers.get_node('Agile/Value')
onready var undead_editor = powers.get_node('Undead/Value')

onready var abilities = powers.get_node('abilities')

onready var unusual_defense_editor = abilities.get_node('UnusualDefense/Value')
onready var unusual_defense_controlled_flag = abilities.get_node('UnusualDefense/Controlled')

onready var counterattack_editor = abilities.get_node('CounterAttack/Value')
onready var mcounterattack_editor = abilities.get_node('MCounterAttack/Value')

onready var regeneration_editor = abilities.get_node('Regeneration/Value')

onready var statustouch_editor = abilities.get_node('StatusTouch/Value')

onready var itemuse_editor = abilities.get_node('ItemUse/Value')

onready var fear_editor = abilities.get_node('Fear/Value')

var tech_points_spent = 0 setget _set_tech_points_spent




func get_element_costs():
	var total = 0
	for itm in elements_editors.get_children():
		total += itm.get_selected()-1
	return total

func get_exceptional_stats_level():
	return ex_stats_editor.get_value()

func calculate_tech_points_spent():
	var points = 0
	points += get_element_costs()
	points += get_exceptional_stats_level()
	
	if points != tech_points_spent:
		self.tech_points_spent = points




func _ready():
	# Set default Element resists
	for itm in elements_editors.get_children():
		itm.set_selected(1)
		itm.connect('button_selected', self, '_on_element_button_selected')

	# Set Unusual Defenses
	unusual_defense_editor.add_item("N/A", 0)
	unusual_defense_editor.add_item("1/2 vs Physical / 2x vs Magic", 1)
	unusual_defense_editor.add_item("1/2 vs Magic / 2x vs Physical", 2)
	unusual_defense_editor.add_item("Swap every 1d2 rounds", 3)
	
	# Set Counterattacks
	counterattack_editor.add_item("N/A", 0)
	counterattack_editor.add_item("10% chance", 1)
	counterattack_editor.add_item("25% chance", 2)
	counterattack_editor.add_item("50% chance", 3)
	
	mcounterattack_editor.add_item("N/A", 0)
	mcounterattack_editor.add_item("10% chance", 1)
	mcounterattack_editor.add_item("25% chance", 2)
	mcounterattack_editor.add_item("50% chance", 3)
	
	regeneration_editor.add_item("N/A", 0)
	regeneration_editor.add_item("+5% HP per round", 1)
	regeneration_editor.add_item("+10% HP per round", 2)
	
	statustouch_editor.add_item("N/A", 0)
	statustouch_editor.add_item("Weak(Lv1)", 1)
	statustouch_editor.add_item("Normal(Lv3)", 2)
	statustouch_editor.add_item("Strong(Lv5)", 3)
	
	itemuse_editor.add_item("N/A", 0)
	itemuse_editor.add_item("Minor", 1)
	itemuse_editor.add_item("Major", 2)
	
	fear_editor.add_item("N/A", 0)
	fear_editor.add_item("Fear", 1)
	fear_editor.add_item("Greater Fear", 2)
	
func _set_tech_points_spent(what):
	tech_points_spent = what
	stats_box.get_node('powers_label/TechPointsSpent').set_text(str(tech_points_spent))


func _on_element_button_selected(idx):
	calculate_tech_points_spent()

func _on_ExceptionalValue_changed(value):
	calculate_tech_points_spent()
	ex_stats_editor.get_node('../ExStatPoints').set_text(str(value*10))
