
extends HBoxContainer

onready var status_window = get_node('/root/Battle/status_window')

onready var hero_battler = preload('res://battler_scenes/hero_battler.res')


func _ready():
	for i in range(3):
		add_hero("Farty")

func add_hero(name):
	var battler = hero_battler.instance()
	add_child(battler)
	
	battler.me = Data.load_hero(name)
	battler.setup()

func untoggle(exception=null):
	for hero in get_children():
		if hero != exception:
			hero.get_node('box/status').set_pressed(false)

func _on_hero_status_toggled(pressed,hero):
	if pressed:
		untoggle(hero)
		status_window.hero = hero.me
		status_window.popup()
	else:
		status_window.hide()


