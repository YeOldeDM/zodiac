
extends Container

onready var info = get_node('info/box')
onready var stats = get_node('stats/box/stats')
onready var level = get_node('level/box')
onready var hpmp = get_node('hpmp/box')
onready var derived = get_node('derived/box')

var monster

var monster_class = preload('res://scripts/monster.gd')

func _ready():
	get_node('save').connect('pressed',self,'_save')
	for stat in ['strength','magic','vitality','spirit','agility']:
		stats.get_node(stat+'/SpinBox').connect("value_changed",self,"_on_stat_value_changed",[stat])
	
	monster = monster_class.Monster.new()
	_draw_stats()
	_draw_vitals()
	_draw_name()
	_draw_level()
	_draw_boss()
	_draw_stats_left()

func _draw_name():
	info.get_node('name_edit').set_text(monster.get_name())

func _draw_level():
	level.get_node('level').set_value(monster.get_level())

func _draw_boss():
	level.get_node('boss').set_pressed(monster.is_boss())

func _draw_vitals():
	_draw_HP()
	_draw_MP()
	_draw_XP()
	_draw_GP()

func _draw_stats():
	_draw_strength()
	_draw_magic()
	_draw_vitality()
	_draw_spirit()
	_draw_agility()

func _draw_stats_left():
	var total = monster.get_strength() + monster.get_magic() +\
				monster.get_vitality() + monster.get_spirit() +\
				monster.get_agility()
	var value = monster.get_total_stats() - total
	stats.get_node('Label').set_text("STATS ("+str(value)+")")

func _draw_strength():
	stats.get_node('strength/SpinBox').set_value(monster.get_strength())
	_draw_derived('attack_power')

func _draw_magic():
	stats.get_node('magic/SpinBox').set_value(monster.get_magic())
	_draw_derived('magic_attack_power')
	_draw_derived('magic_accuracy')
	_draw_derived('tech')

func _draw_vitality():
	stats.get_node('vitality/SpinBox').set_value(monster.get_vitality())
	_draw_HP()
	_draw_derived('resist')

func _draw_spirit():
	stats.get_node('spirit/SpinBox').set_value(monster.get_spirit())
	_draw_MP()
	_draw_derived('resist')

func _draw_agility():
	stats.get_node('agility/SpinBox').set_value(monster.get_agility())
	_draw_derived('accuracy')
	_draw_derived('evade')
	_draw_derived('critical')
	_draw_derived('speed')

func _draw_HP():
	hpmp.get_node('hp/value').set_text(str(monster.get_HP()))

func _draw_MP():
	hpmp.get_node('mp/value').set_text(str(monster.get_MP()))

func _draw_XP():
	hpmp.get_node('xp/value').set_text(str(monster.get_XP()))

func _draw_GP():
	hpmp.get_node('gp/value').set_text(str(monster.get_GP()))

func _draw_derived(stat):
	var label = derived.get_node(str(stat,'/value'))
	var text = str(monster.call(str('get_',stat)))
	if stat == 'critical':
		text += "%"
	label.set_text(text)
	

func _save():
	Data.save_monster(monster)

func _on_name_edit_text_entered( text ):
	monster.set_name(text)
	printt("Monster name set:",text)



func _on_stat_value_changed(value,stat):
	monster.call("set_"+stat,value)
	call("_draw_"+stat)
	_draw_stats_left()

func _on_level_value_changed( value ):
	monster.set_level(value)
	_draw_vitals()
	_draw_stats_left()


func _on_boss_toggled( pressed ):
	monster.set_boss(pressed)
	_draw_vitals()