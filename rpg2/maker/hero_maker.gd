
extends PanelContainer

onready var stats_box = get_node('box/stats')
onready var info = stats_box.get_node('info')
onready var stats = stats_box.get_node('stats')
onready var stat_editors = stats.get_node('values')

onready var skills = stats_box.get_node('skills')

onready var derived_box = get_node('box/derived')
onready var derived_vitals = derived_box.get_node('vitals')
onready var derived_stats = derived_box.get_node('stats')
onready var derived_stats_A = derived_stats.get_node('A')
onready var derived_stats_B = derived_stats.get_node('B')

onready var command_skill_box = skills.get_node('command/select/selector')
onready var support_skill_box = skills.get_node('support/select/selector')

var valid_command_skills = []
var valid_support_skills = [
	RPG.SUPPORT_SKILL_ATTACKUP,
	RPG.SUPPORT_SKILL_MAGICUP,
	RPG.SUPPORT_SKILL_TOUGHNESS,
	RPG.SUPPORT_SKILL_QUICKNESS,
	RPG.SUPPORT_SKILL_MENTALSTRENGTH,
	RPG.SUPPORT_SKILL_FLIGHT,]

var data = Hero.Hero.new("Testeroni")

func get_data_tree():
	var dir = Directory.new()
	if dir.open('res://data/hero') != OK:
		return null
	var data = []
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != '':
		if  file.ends_with('.hero'):
			data.append(file)
		file = dir.get_next()
	dir.list_dir_end()
	return data


func _draw_info():
	_draw_name()
	_draw_job()
	_draw_level()

func _draw_stats():
	for i in stats.get_node('values').get_children():
		_draw_stat(i.get_name())

func _draw_derived_stats():
	for i in derived_stats_A.get_node('values').get_children():
		_draw_derived(i.get_name())
	for e in derived_stats_B.get_node('values').get_children():
		_draw_derived(e.get_name())

func _draw_name():
	info.get_node('values/name').set_text(data.name)
func _draw_job():
	info.get_node('values/job').set_text(data.job)
func _draw_level():
	info.get_node('values/level').set_value(data.level)

func _draw_stat(stat):
	stats.get_node('values/'+stat).set_value(data.get_stat(stat))

func _draw_derived(stat):
	#print(stat)
	var passed = false
	for child in derived_stats_A.get_node('values').get_children():
		if child.get_name() == stat:
			child.set_text(str(data.get_derived_score(stat)))
			passed = true
	if not passed:
		for child in derived_stats_B.get_node('values').get_children():
			if child.get_name() == stat:
				child.set_text(str(data.get_derived_score(stat)))

func _draw_HP():
	var value = data.get_max_HP()
	derived_vitals.get_node('HP/value').set_text(str(value))

func _draw_MP():
	var value = data.get_max_MP()
	derived_vitals.get_node('MP/value').set_text(str(value))

func _ready():
	for child in stat_editors.get_children():
		child.connect("value_changed", self, "_on_stat_value_changed", [child.get_name()])
	_set_skills()
	update()
	
func update():
	_draw_info()
	_draw_stats()
	_draw_derived_stats()
	_draw_HP()
	_draw_MP()
	command_skill_box.select(data.command_skill)
	_draw_command_description()
	support_skill_box.select(data.support_skill)
	_draw_support_description()
	

func _set_skills():
	_set_command_skills()
	_set_support_skills()

func _set_command_skills():
	var skill_list = RPG.command_skill_names
	var csb = command_skill_box
	var i = 0
	for skill in skill_list:
		csb.add_item(skill, i)
		if not i in valid_command_skills:
			#csb.set_item_disabled(i,true)
			csb.set_item_text(i,csb.get_item_text(i)+"[T.B.A.]")
		i += 1

func _draw_command_description():
	var box = skills.get_node('command/description')
	box.clear()
	box.set_bbcode(Ref.COMMAND_SKILLS[data.command_skill])

func _draw_support_description():
	var box = skills.get_node('support/description')
	box.clear()
	box.set_bbcode(Ref.SUPPORT_SKILLS[data.support_skill])


func _set_support_skills():
	var i = 0
	var ssb = support_skill_box
	var skill_list = RPG.support_skill_names
	for skill in skill_list:
		ssb.add_item(skill, i)
		if not i in valid_support_skills:
			#ssb.set_item_disabled(i,true)
			ssb.set_item_text(i,ssb.get_item_text(i)+"[T.B.A.]")
		i += 1



func _on_name_text_changed( text ):
	if not text.empty():
		data.name = text


func _on_job_text_changed( text ):
	if not text.empty():
		data.job = text


func _on_level_value_changed( value ):
	data.level = value
	_draw_stats()
	_draw_derived_stats()
	_draw_HP()
	_draw_MP()

func _on_stat_value_changed( value, stat ):
	data.set_stat(stat, value - data._get_stat_bonus_from_lvl())
	_draw_derived_stats()
	_draw_HP()
	_draw_MP()

func _on_command_item_selected( ID ):
	data.command_skill = ID
	_draw_command_description()
	update()


func _on_support_item_selected( ID ):
	data.support_skill = ID
	_draw_support_description()
	update()


func _on_save_pressed():
	Data.save_hero(data)
	get_node('../../').refresh_tree(get_data_tree())
