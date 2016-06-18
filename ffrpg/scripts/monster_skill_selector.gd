
extends HSplitContainer

onready var selector = get_node('Tree')

var Added = []	#temporary

func _ready():
	selector.set_hide_root(true)
	var root = selector.create_item(self)
	
	var levels = {}
	for L in ["LX","L0","L1","L2","L3","L4","L5","L6"]:
		var itm = selector.create_item(root)
		itm.set_text(0,L)
		itm.set_selectable(0,false)
		levels[L] = itm
	

	for stat in ["Exceptional Stats","Final Attack",\
				"Combination Attack","Multiple Parts"]:
		var itm = selector.create_item(levels['LX'])
		itm.set_text(0,stat)
	
	for stat in ["Undead","Unusual Defense","Weakness"]:
		var itm = selector.create_item(levels['L0'])
		itm.set_text(0,stat)
		
	


