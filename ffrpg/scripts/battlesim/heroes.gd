
extends HBoxContainer

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')
onready var status_window = get_node('/root/Battle/status_window')

onready var hero_battler = preload('res://battler_scenes/hero_battler.res')

#temporary list of heroes to load up
var hero_list = [
	'Fess',
	'Pale',
	'Barry',
	'Dexter'
	]

#initialize hero battlers from hero list
func _ready():
	for guy in hero_list:
		add_hero(guy)

#get a list of heroes
func get_heroes():
	return get_children()

#add a hero battler
#load .zd file by name
func add_hero(name):
	var battler = hero_battler.instance()
	add_child(battler)
	
	battler.name.connect("toggled",status_window,"_on_status_toggled",[battler])
	var path = 'res://data/heroes/'+name+'.hero'
	battler.me = Data.load_hero(path)
	battler.setup()
	msg.say("Added Hero "+battler.me.get_name())

#un-press all hero status buttons,
#with an optional exception
func untoggle(exception=null):
	for hero in get_children():
		if hero != exception:
			hero.get_node('box/status').set_pressed(false)

#Hero status toggls superfunction
func _on_hero_status_toggled(pressed,hero):
	if pressed:
		untoggle(hero)
		get_node('/root/Battle/box/battle/monsters/box/list').untoggle(hero)
		status_window.hero = hero.me
		status_window.popup()
	else:
		status_window.hide()


