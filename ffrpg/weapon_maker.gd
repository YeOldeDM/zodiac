
extends Tabs

const power_settings = {
	-2:	[5,1],
	-1:	[4,2],
	0:	[3,3],
	1:	[2,4],
	2:	[1,5]
	}

var current_lvl
var specials = {
	1:	[],
	2:	[],
	3:	[],
	4:	[],
	5:	[],
	6:	[],
	7:	[],
	8:	[],
	9:	[],
	10:	[]
	}

var max_points = 10
var spent_points = 0

var max_artifact_points = 4
var spent_artifact_points = 0

#gets the array of ints from power_settings w/ power_set as index
var power_set = 0 setget ,_get_power_settings

onready var info = get_node('Info/box')
onready var file = get_node('File/box')
onready var power = get_node('Power/box/box')
onready var stats = get_node('Stats/grid')
var APs = []
var MAPs = []

onready var power_label = power.get_node('power/value')
onready var magic_label = power.get_node('magic/value')
onready var power_slider = power.get_node('slider')

onready var set_name = info.get_node('name')
onready var save_button = file.get_node('save')
onready var load_button = file.get_node('load')

onready var special_maker = get_node('special_maker')

var WC = preload('res://scripts/weapon.gd')

func _ready():
	update_stats()
	set_name.set_text("!! UNNAMED WEAPON SET !!")
	for i in range(1,11):
		var name = stats.get_node('name'+str(i))
		name.set_text("!!==- UNNAMED WEAPON LV "+str(i)+" -==!!")
		var node = stats.get_node('special'+str(i))
		node.connect('pressed',self,'_on_special_button_pressed',[i])
	#special_maker.show()

func add_special(lvl,effect):
	if not effect in specials[lvl]:
		specials[lvl].append(effect)
		var button = Button.new()
		

func update_stats():
	var P = get('power_set')
	var C = Chart.weapon_attack_chart
	for i in range(1,11):
		_draw_stat("ap",i,C[P[0]-1][i-1])
		_draw_stat("map",i,C[P[1]-1][i-1])

func _draw_stat(stat,lvl,value):
	var v = "+"+str(value)
	stats.get_node(stat+str(lvl)).set_text(v)

func _get_weapon_name(lvl):
	var N = stats.get_node('name'+str(lvl)).get_text()
	if N == "":	#name slot has been left blank..
		N = "!!==- UNNAMED WEAPON LV "+str(lvl)+" -==!!"
	return N

func _get_power_settings():
	return power_settings[power_set]




func _on_slider_value_changed( value ):
	power_set = int(value)
	var P = get('power_set')
	power_label.set_text(str(P[0]))
	magic_label.set_text(str(P[1]))
	update_stats()



func _pack_weapons():
	#create a json-ready dict of all weapons, keyed by level 1-10
	var pack = {}
	for i in range(1,11):
		var name = _get_weapon_name(i)
		var level = i
		var P = get('power_set')
		var power = P[0]
		var magic = P[1]
		var W = WC.Weapon.new(name,level,power,magic,[])
		pack[str(i)] = inst2dict(W)
	return pack

func _on_special_button_pressed(lvl):
	current_lvl = lvl
	special_maker.show()

func _on_save_pressed():
	var pack = _pack_weapons()
	print(pack)


func _on_load_pressed():
	pass # replace with function body


