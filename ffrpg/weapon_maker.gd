
extends Tabs

const power_settings = {
	-2:	[5,1],
	-1:	[4,2],
	0:	[3,3],
	1:	[2,4],
	2:	[1,5]
	}

onready var info = get_node('Info/box')
onready var file = get_node('File/box')
onready var power = get_node('Power/box/box')
onready var stats = get_node('Stats/box')

onready var power_label = power.get_node('power/value')
onready var magic_label = power.get_node('magic/value')
onready var power_slider = power.get_node('slider')

onready var name = info.get_node('name')
onready var save_button = file.get_node('save')
onready var load_button = file.get_node('load')


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


