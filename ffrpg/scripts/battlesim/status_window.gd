
extends Popup

onready var panel = get_node('panel')
onready var box1 = panel.get_node('box/1')
onready var box2 = panel.get_node('box/2')
onready var box3 = panel.get_node('box/3')

onready var info = box1.get_node('box/info/box')
onready var name = info.get_node('name')
onready var level = info.get_node('level')
onready var XP = info.get_node('XP')
onready var to_next = info.get_node('to_next')

onready var stats = box1.get_node('box/stats/box')
onready var str_label = stats.get_node('strength/value')
onready var mag_label = stats.get_node('magic/value')
onready var vit_label = stats.get_node('vitality/value')
onready var spr_label = stats.get_node('spirit/value')
onready var agi_label = stats.get_node('agility/value')

onready var derived = box2.get_node('box/derived/box')
onready var attack_power_label = derived.get_node('attack_power/value')
onready var magic_attack_power_label = derived.get_node('magic_attack_power/value')
onready var accuracy_label = derived.get_node('accuracy/value')
onready var magic_accuracy_label = derived.get_node('magic_accuracy/value')
onready var evade_label = derived.get_node('evade/value')
onready var resist_label = derived.get_node('resist/value')
onready var speed_label = derived.get_node('speed/value')
onready var critical_label = derived.get_node('critical/value')

onready var hpmp = box2.get_node('box/hpmp/box')
onready var HP_label = hpmp.get_node('HP/value')
onready var MP_label = hpmp.get_node('MP/value')

onready var gear = box3.get_node('box/values')
onready var weapon_label = gear.get_node('weapon')
onready var armor_label = gear.get_node('armor')
onready var guard_label = gear.get_node('guard')
onready var misc_label = gear.get_node('misc')

var hero = null

func _on_status_window_about_to_show():
	print(hero.name)
