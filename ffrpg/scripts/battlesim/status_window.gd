
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
onready var strength = stats.get_node('strength/value')
onready var magic = stats.get_node('magic/value')
onready var vitality = stats.get_node('vitality/value')
onready var spirit = stats.get_node('spirit/value')
onready var agility = stats.get_node('agility/value')

onready var derived = box2.get_node('box/derived/box')
onready var attack_power = derived.get_node('attack_power/value')
onready var magic_attack_power = derived.get_node('magic_attack_power/value')
onready var accuracy = derived.get_node('accuracy/value')
onready var magic_accuracy = derived.get_node('magic_accuracy/value')
onready var evade = derived.get_node('evade/value')
onready var resist = derived.get_node('resist/value')
onready var speed = derived.get_node('speed/value')
onready var critical = derived.get_node('critical/value')

onready var hpmp = box2.get_node('box/hpmp/box')
onready var HP = hpmp.get_node('HP/value')
onready var MP = hpmp.get_node('MP/value')

onready var gear = box3.get_node('box/values')
onready var weapon = gear.get_node('weapon')
onready var armor = gear.get_node('armor')
onready var guard = gear.get_node('guard')
onready var misc = gear.get_node('misc')

var hero = null

func _on_status_window_about_to_show():
	name.set_text(hero.get_name())
	level.set_text("Level "+str(hero.get_level()))
	XP.set_text("XP "+str(hero.xp))
	to_next.set_text("to next "+str(hero.get_xp_to_level(hero.get_level()+1)))
	
	for stat in ['strength','magic','vitality','spirit','agility']:
		get(stat).set_text(str(hero.call('get_'+stat)))
	for stat in ['attack_power','magic_attack_power',
				'accuracy','magic_accuracy',
				'evade','resist','speed','critical']:
		get(stat).set_text(str(hero.call('get_'+stat)))
	HP.set_text(str(hero.current_HP)+"/"+str(hero.get_HP()))
	MP.set_text(str(hero.current_MP)+"/"+str(hero.get_MP()))
	
	weapon.set_text(hero.get_weapon().name)
	armor.set_text(hero.get_armor().name)
	guard.set_text(hero.get_guard().name)
	misc.set_text("N/A")