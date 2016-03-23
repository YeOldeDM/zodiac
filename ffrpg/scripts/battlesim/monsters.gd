
extends GridContainer

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')
onready var status_window = get_node('/root/Battle/status_window')

onready var monster_battler = preload('res://battler_scenes/monster_battler.res')

func _ready():
	for i in range(3):
		add_monster("Green Blob")

func get_monsters():
	return get_children()

func add_monster(name):
	var battler = monster_battler.instance()
	add_child(battler)
	battler.name.connect("toggled",status_window,"_on_status_toggled",[battler])
	battler.me = Data.load_monster(name)
	battler.setup()
	msg.say("Added Monster "+battler.me.get_name())

func untoggle(exception=null):
	for mob in get_children():
		if mob != exception:
			mob.get_node('box/status').set_pressed(false)
