
extends HBoxContainer

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')
onready var status_window = get_node('/root/Battle/status_window')

onready var hero_battler = preload('res://battler_scenes/hero_battler.res')


func _ready():
	for i in range(3):
		add_hero("Farty")

func get_heroes():
	return get_children()

func add_hero(name):
	var battler = hero_battler.instance()
	add_child(battler)
	
	battler.name.connect("toggled",status_window,"_on_status_toggled",[battler])
	battler.me = Data.load_hero(name)
	battler.setup()
	msg.say("Added Hero "+battler.me.get_name())

func untoggle(exception=null):
	for hero in get_children():
		if hero != exception:
			hero.get_node('box/status').set_pressed(false)

func _on_hero_status_toggled(pressed,hero):
	if pressed:
		untoggle(hero)
		get_node('/root/Battle/box/battle/monsters/box/list').untoggle(hero)
		status_window.hero = hero.me
		status_window.popup()
	else:
		status_window.hide()


