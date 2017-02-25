
extends PopupPanel

const MODE_ACTION = 0
const MODE_TARGET = 1
const MODE_TECH = 2
const MODE_ITEM = 3


onready var battle = get_node('/root/Battle')


var COMBAT_ACTIONS = {
	'Fight':	RPG.BATTLEACTION_FIGHT,
	}


var mode = MODE_ACTION

onready var title = get_node('box/Title')
onready var nametag = get_node('box/Name')
onready var actions = get_node('box/Actions')






func clear_actions():
	for child in actions.get_children():
		child.queue_free()

func add_action(name, callback):
	var button = Button.new()
	button.set_text(name)
	button.connect("pressed", self, '_callback_action', [callback])
	actions.add_child(button)



func draw_window():
	if mode == MODE_ACTION:
		draw_battle_actions()
	elif mode == MODE_TARGET:
		draw_target_actions()


func draw_battle_actions():
	title.set_text("Select Action for:")
	var name = "NONAME"
	if battle._data:
		name = battle._data.owner.data.name
	nametag.set_text(name)
	clear_actions()
	for key in COMBAT_ACTIONS:
		add_action(key, COMBAT_ACTIONS[key])


func draw_target_actions():
	title.set_text("Select target for:")
	var name = "NONAME"
	if battle._data:
		name = battle._data.owner.data.name
	nametag.set_text(name)
	if battle._data:
		var own = battle._data.owner
		
		var targets = battle.get_monsters()
		if own.is_monster:
			targets = battle.get_heroes()
		
		clear_actions()

		for member in targets:
			if member in battle.active_fighters:
				add_action(member.data.name, member.get_name())


func _callback_action( callback_id ):
	if mode == MODE_ACTION:
		battle._data.action = callback_id
		if callback_id == MODE_ACTION:
			mode = MODE_TARGET
			draw_window()
	
	
	elif mode == MODE_TARGET:
		var tlist = 'Heroes'
		if battle._data.nature == RPG.BATTLEACTION_HOSTILE:
			if battle._data.owner.is_hero:
				tlist = 'Monsters'
		elif battle._data.nature == RPG.BATTLEACTION_ACTION_FRIENDLY:
			if battle._data.owner.is_monster:
				tlist = 'Monsters'
		var T = battle.get_node('frame/'+tlist+'/box/'+callback_id)
		battle._data.targets.append(T)
		battle.action_ready = true
		battle.go_timer.start()
		hide()
		


func _on_ActionDialog_about_to_show():
	mode = 0
	draw_window()
