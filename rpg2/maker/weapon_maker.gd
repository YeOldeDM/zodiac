
extends PanelContainer

onready var stats = get_node('box/stats')
onready var info = stats.get_node('info')
onready var power = stats.get_node('power/box')
onready var derived = get_node('box/derived')
onready var vitals = derived.get_node('vitals')
onready var cost = derived.get_node('cost')
onready var specials = stats.get_node('specials')

onready var special1_box = specials.get_node('special1/select/selector')
onready var special2_box = specials.get_node('special2/select/selector')

var data = Equipment.Weapon.new()

var valid_weapon_specials = []

func get_data_tree():
	var dir = Directory.new()
	if dir.open('res://data/equipment/weapon') != OK:
		return null
	var data = []
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != '':
		if  file.ends_with('.weapon'):
			data.append(file)
		file = dir.get_next()
	dir.list_dir_end()
	return data

func update():
	_draw_info()
	draw_power_scores()
	draw_cost()

func _draw_info():
	_draw_name()
	_draw_set()
	_draw_level()

	
	power.get_node('power_slider').set_value(6-data.power_setting[0])
	draw_power_settings()

func _draw_name():
	info.get_node('values/name').set_text(data.name)
func _draw_set():
	info.get_node('values/set').set_text(data.set)
func _draw_level():
	info.get_node('values/level').set_value(data.level)

func _ready():
	power.get_node('power_slider').set_value(6-data.power_setting[0])
	info.get_node('values/name').set_text(data.name)
	info.get_node('values/set').set_text(data.set)
	info.get_node('values/level').set_value(data.level)
	_set_specials()
	draw_power_scores()
	draw_power_settings()
	draw_cost()




func draw_power_settings():
	power.get_node('physical/value').set_text(str(data.power_setting[0]))
	power.get_node('magic/value').set_text(str(data.power_setting[1]))

func draw_power_scores():
	vitals.get_node('AP/value').set_text(str(data.get_AP()))
	vitals.get_node('MAP/value').set_text(str(data.get_MAP()))

func draw_cost():
	var txt = str(data.get_cost())
	if not txt: txt = "N/A"
	cost.get_node('value').set_text(txt)


func _set_specials():
	var spec_list = Equipment.weapon_specials
	var menus = [special1_box, special2_box]
	var i = 0
	for spec in spec_list:
		for ob in menus:
			ob.add_item(spec[0], i)
		if not i in valid_weapon_specials:
			for ob in menus:
				#csb.set_item_disabled(i,true)
				ob.set_item_text(i,ob.get_item_text(i)+"[T.B.A.]")
		i += 1

func _on_power_slider_value_changed( value ):
	data.power_setting = [6-value, value]
	draw_power_settings()
	draw_power_scores()
	


func _on_level_value_changed( value ):
	data.level = value
	draw_power_scores()
	draw_cost()


func _on_name_text_changed( text ):
	data.name = text


func _on_set_text_changed( text ):
	data.set = text


func _on_save_pressed():
	var callback = Data.save_weapon(data)
	print("SAVED " + data.name)
	get_node('../../').refresh_tree(get_data_tree())
