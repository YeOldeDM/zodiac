
extends AcceptDialog

onready var owner = get_parent()

var specials = {
	0:	[ 'dedicated', 2, 'beast' ],
	1:	[ 'drainweapon', 3 ],
	2:	[ 'elemental', 0 ],
	3:	[ 'keenedge', 2 ],
	4:	[ 'spelleffect', 2, null ],	#not implemented yet
	5:	[ 'statbonus', 2, 'MAG'],
	6:	[ 'statuseffect', [2,3], StatusEffect.BLIND],
	}

var working_specials = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_effect_choice_item_selected( ID ):
	printt(ID, specials[ID-1])
