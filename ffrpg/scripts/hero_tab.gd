
extends VBoxContainer

onready var tree = get_node('box/Files/Tree')
onready var info = get_node('box/Info').get_child(0)
var root
var path = "res://data/heroes"

func _ready():
	root = tree.create_item()
	root.set_text(0,"Heroes")
	_show_heroes()

func _show_heroes():
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Directory:"+file_name)
			else:
				print("File:"+file_name)
				var F = tree.create_item(root)
				F.set_meta('path',path+'/'+file_name)
				var name = file_name.replace('.hero','')
				F.set_text(0,name)
			file_name = dir.get_next()
	else:
		print("Error!")
	
	




func _on_Tree_cell_selected():
	var path = tree.get_selected().get_meta('path')
	info.restore(path)


func _on_Refresh_pressed():
	_show_heroes()
