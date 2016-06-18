
extends GridContainer

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')
onready var status_window = get_node('/root/Battle/status_window')

onready var monster_battler = preload('res://battler_scenes/monster_battler.res')

var monster_list = [
	"Green Blob",
	]

func _ready():
	for guy in monster_list:
		add_monster(guy)

#get a list of current monsters
func get_monsters():
	return get_children()

#add a monster battler
#load .zd file by name
func add_monster(name):
	var battler = monster_battler.instance()
	add_child(battler)
	battler.name.connect("toggled",status_window,"_on_status_toggled",[battler])
	battler.me = Data.load_monster('res://data/monsters/'+name+'.monster')
	battler.setup()
	msg.say("Added Monster "+battler.me.get_name())

#un-press all monster status buttons,
#with an optional exception
func untoggle(exception=null):
	for mob in get_children():
		if mob != exception:
			mob.get_node('box/status').set_pressed(false)
