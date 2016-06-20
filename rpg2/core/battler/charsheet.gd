
extends WindowDialog

onready var data = get_parent().data
onready var info = get_node('info')
onready var sheet = get_node('sheet')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _draw_score(category, stat, value):
	var txt = sheet.get_node(category+'/scores/'+stat)
	txt.set_text(str(value))

func _on_SheetPopup_about_to_show():
	pass # replace with function body
