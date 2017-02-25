
extends WindowDialog

onready var data = get_parent().data
onready var info = get_node('info')
onready var sheet = get_node('sheet')

func _is_hero():
	if data extends Hero.Hero:
		return true
	return false

func _draw_level():
	var txt = "Lvl "+Format.number(data.level)
	if !_is_hero() and data.is_boss:
		txt += " Boss"
	info.get_node('Level').set_text(txt)

func _draw_XP():
	var txt = null
	if _is_hero():
		txt = Format.number(data.XP)+'/'+Format.number(data.get_XP_to_level(data.level+1))
	else:
		txt = Format.number(data.get_XP_value())
	info.get_node('XP').set_text("XP " + txt)

func _draw_score(category, stat, value):
	var txt = sheet.get_node(category+'/scores/'+stat)
	txt.set_text(str(value))



func _on_SheetPopup_about_to_show():
	if !data:
		# Break out with an error if no data is set
		OS.alert("No data found for this battler")
		return
	set_title(data.name)
	_draw_level()
	_draw_XP()
	
	# draw stats
	for stat in ['strength','magic','vitality','spirit','agility']:
		_draw_score('stats', stat, data.get_stat(stat))
	
	# draw HP/MP
	_draw_score('stats','HP', data.get_max_HP())
	_draw_score('stats','MP', data.get_max_MP())
	
	# draw derived stats
	_draw_score('derived', 'AP', data.get_attack_power())
	_draw_score('derived', 'MAP', data.get_magic_attack_power())
	_draw_score('derived', 'ACC', data.get_accuracy())
	_draw_score('derived', 'MACC', data.get_magic_accuracy())
	_draw_score('derived', 'EVA', data.get_evade())
	_draw_score('derived', 'RES', data.get_resist())
	_draw_score('derived', 'CRIT', data.get_critical())
	_draw_score('derived', 'SPD', data.get_speed())