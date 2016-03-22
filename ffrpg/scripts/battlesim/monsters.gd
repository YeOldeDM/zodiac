
extends GridContainer

onready var status_window = get_node('/root/Battle/status_window')

onready var monster_battler = preload('res://battler_scenes/monster_battler.res')

func _ready():
	for i in range(3):
		add_monster("Green Blob")

func add_monster(name):
	var battler = monster_battler.instance()
	add_child(battler)
	
	battler.me = Data.load_monster(name)
	battler.setup()

func untoggle(exception=null):
	for mob in get_children():
		if mob != exception:
			mob.get_node('box/status').set_pressed(false)
