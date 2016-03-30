
extends Container

var done_command_skills = [
#placeholder for command skills which
#have been implemented.
]

var done_support_skills = [
#placeholder for support skills which
#have been implemented.
	"Attack Up",
	"Magic Up",
	"Toughness",
	"Mental Strength",
	"Quickness",
]
#eventually these will be reversed,
#when there are more done skills than
#non-done.

onready var info = get_node('info/box')
onready var stats = get_node('stats/box/stats')
onready var weights = get_node('stats/box/weight')
onready var level = get_node('level/box')
onready var hpmp = get_node('hpmp/box')
onready var derived = get_node('derived/box')
onready var skills = get_node('skills/box')

var hero

var hero_class = preload('res://scripts/hero.gd')
var weapon_class = preload('res://scripts/weapon.gd')
var armor_class = preload('res://scripts/armor.gd')
var guard_class = preload('res://scripts/guard.gd')

func _ready():
	randomize()
	var weapon = weapon_class.Weapon.new()
	var armor = armor_class.Armor.new()
	var guard = guard_class.Guard.new()
	hero = hero_class.Hero.new()
	hero.equip_weapon(weapon)
	hero.equip_armor(armor)
	hero.equip_guard(guard)
	_set_skills()
	_connect()
	_draw_sheet()

func _set_skills():
	var command = skills.get_node('command')
	var support = skills.get_node('support')
	command.add_item("Command Skill")
	command.set_item_disabled(0,true)
	command.add_separator()
	support.add_item("Support Skill")
	support.set_item_disabled(0,true)
	support.add_separator()
	for skill in Chart.command_skills:
		command.add_item(skill)
	for skill in Chart.support_skills:
		support.add_item(skill)
	
	#disable TBA skills
	for i in range(1,command.get_item_count()):
		if not command.get_item_text(i) in done_command_skills:
			command.set_item_disabled(i,true)
	for i in range(1,support.get_item_count()):
		if not support.get_item_text(i) in done_support_skills:
			support.set_item_disabled(i,true)


func _connect():
	get_node('save').connect("pressed",self,'save')
	#connect name edit
	info.get_node('name_edit').connect("text_entered",self,'_on_name_edit_text_entered')
	#connect level
	level.get_node('SpinBox').connect("value_changed",self,"_on_level_SpinBox_value_changed")
	#connect stats
	for stat in ['strength','magic','vitality','spirit','agility']:
		stats.get_node(stat+'/SpinBox').connect("value_changed",self,"_on_stat_SpinBox_value_changed",[stat])
		weights.get_node(stat).connect("value_changed",self,"_on_weight_value_changed",[stat])
	skills.get_node('command').connect("item_selected",self,"_on_command_skill_selected")
	skills.get_node('support').connect("item_selected",self,"_on_support_skill_selected")
	
func save():
	Data.save_hero(hero)


func restore(name):
	var temp_hero = Data.load_hero(name)
	if temp_hero:
		hero = temp_hero
		_draw_sheet()
		_draw_skills()
	else:
		print(name+" returned null result. That's no good!")
	
func _draw_sheet():
	_draw_name()
	_draw_stats()
	_draw_weights()

func _draw_skills():
	var support = hero.support_skill
	var support_node = skills.get_node('support')
	for i in range(support_node.get_item_count()-1):
		if support_node.get_item_text(i) == support:
			support_node.select(i)
			return
	support_node.select(0)


func _draw_name(name=null):
	var label = info.get_node('name_edit')
	if name:
		label.set_text(name)
	else:
		label.set_text(hero.get_name())

func _draw_weights():
	var stats = ['strength','magic','vitality','spirit','agility']
	for stat in stats:
		_draw_weight(stat)

func _draw_weight(stat):
	var value = hero.get_weight(stat)
	weights.get_node(stat).set_value(value)

func _draw_stats_left():
	var total_stats = (hero.get_strength() + hero.get_magic() +\
						hero.get_vitality() + hero.get_spirit()+\
						hero.get_agility())
	var left = 40 - total_stats
	stats.get_node('Label').set_text("STATS ("+str(left)+")")

func _draw_stats():
	_draw_strength()
	_draw_magic()
	_draw_vitality()
	_draw_spirit()
	_draw_agility()
	_draw_stats_left()

func _draw_strength():
	var label = stats.get_node('strength/SpinBox')
	label.set_value(hero.get_strength())
	_draw_derived('attack_power')

func _draw_magic():
	var label = stats.get_node('magic/SpinBox')
	label.set_value(hero.get_magic())
	_draw_derived('magic_attack_power')
	_draw_derived('magic_accuracy')

func _draw_vitality():
	var label = stats.get_node('vitality/SpinBox')
	label.set_value(hero.get_vitality())
	_draw_HP()
	_draw_derived('resist')

func _draw_spirit():
	var label = stats.get_node('spirit/SpinBox')
	label.set_value(hero.get_spirit())
	_draw_MP()
	_draw_derived('resist')

func _draw_agility():
	var label = stats.get_node('agility/SpinBox')
	label.set_value(hero.get_agility())
	_draw_derived('accuracy')
	_draw_derived('evade')
	_draw_derived('critical')
	_draw_derived('speed')

func _draw_HP():
	var label = hpmp.get_node('hp/value')
	label.set_text(str(hero.get_HP()))

func _draw_MP():
	var label = hpmp.get_node('mp/value')
	label.set_text(str(hero.get_MP()))

func _draw_derived(stat):
	var label = derived.get_node(str(stat,'/value'))
	var text = str(hero.call(str('get_',stat)))
	if stat == 'critical':
		text += "%"
	label.set_text(text)



##	SIGNAL FUNCS	##
func _on_name_edit_text_entered( text ):
	hero.set_name(text)
	prints("Set hero name:",text)


func _on_stat_SpinBox_value_changed( value,stat ):
	hero.call(str("set_",stat),(value-hero._get_stat_from_lvl()))
	call("_draw_"+stat)
	printt("Set hero",stat,value)
	_draw_stats_left()


func _on_level_SpinBox_value_changed( value ):
	hero.set_level(value)
	printt("Set hero Level to",value)
	_draw_stats()


func _on_weight_value_changed( value,stat ):
	hero.set_weight(stat,value)

func _on_command_skill_selected(id):
	var skill = skills.get_node('command').get_item_text(id)
	hero.command_skill = skill
	printt("Set Hero Command Skill",skill)
	_draw_sheet()

func _on_support_skill_selected(id):
	var skill = skills.get_node('support').get_item_text(id)
	hero.support_skill = skill
	printt("Set Hero Support Skill",skill)
	_draw_sheet()
	
func _on_save_hero_pressed():
	save()


func _on_load_pressed():
	var load_name = get_node('load/box/load_name').get_text()
	var path = 'res://data/heroes/'+load_name+'.zd'
	var file = File.new()
	if file.file_exists(path):
		restore(load_name)
	else:
		print("\nTHIS FILE EXISTS NOT!! TRY AGAIN.")
