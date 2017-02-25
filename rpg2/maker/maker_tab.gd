
extends Tabs

onready var data_tree = get_node('box/box/Tree')
onready var workbench = get_node('box/Workbench')


func _ready():
	data_tree.set_hide_root(true)
	if workbench.has_method('get_data_tree'):
		refresh_tree(workbench.get_data_tree())

func refresh_tree(data):
	var tree = data_tree
	tree.clear()
	var root = tree.create_item()
	if data == null:	return
	for item in data:
		var treeitem = tree.create_item(root)
		treeitem.set_text(0, item)
	

func _on_Refresh_pressed():
	var data = workbench.get_data_tree()
	refresh_tree(data)


func _on_Select_pressed():
	var name = data_tree.get_selected().get_text(0)
	var data = null
	if name.ends_with('.hero'):
		data = Data.load_hero(name)
	elif name.ends_with('.weapon'):
		data = Data.load_weapon(name)
	if data:
		workbench.data = data
		workbench.update()
