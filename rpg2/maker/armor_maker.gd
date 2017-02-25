
extends PanelContainer

const type_strings = [
	'Enhance',
	'Balanced',
	'Defense'
	]

onready var stats = get_node('box/stats')
onready var info = stats.get_node('info')
onready var power = stats.get_node('power/box')
onready var derived = get_node('box/derived')
onready var vitals = derived.get_node('vitals')

var data = Equipment.Armor.new()

func _ready():
	power.get_node('type_slider').set_value(data.type)
	info.get_node('values/name').set_text(data.name)
	info.get_node('values/set').set_text(data.set)
	info.get_node('values/level').set_value(data.level)
	draw_power_scores()
	draw_power_settings()


func draw_power_settings():
	power.get_node('type/value').set_text(type_strings[data.type])
	

func draw_power_scores():
	vitals.get_node('HP/value').set_text(str(data.get_HP()))
	vitals.get_node('MP/value').set_text(str(data.get_MP()))


func _on_level_value_changed( value ):
	data.level = value
	draw_power_scores()


func _on_name_text_changed( text ):
	data.name = text


func _on_set_text_changed( text ):
	data.set = text


func _on_type_slider_value_changed( value ):
	data.type = value
	draw_power_settings()
	draw_power_scores()
