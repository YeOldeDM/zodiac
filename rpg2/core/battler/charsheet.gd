
extends WindowDialog

onready var info = get_node('info')
onready var sheet = get_node('sheet')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _draw_score(category, stat, value):
	txt = sheet.get_node(category+'/scores/'+stat)
	txt.set_text(str(value))