
extends Container

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')

onready var heroes = get_node('box/heroes')
onready var monsters = get_node('box/battle/monsters/box/list')
onready var combat = get_node('box/options/actions/combat')

var actors = []
var current_actor = 0
var current_target = null
var current_action = null

var needs_target = true

var is_hero = false	#is the current actor a hero?

func _ready():
	randomize()
	build_actors()
	pre_battle()
	set_process(true)

func _process(delta):
	if not is_hero:
		actors[current_actor].me.spend_speed()
		actors[current_actor].draw_battler()
		next_turn()
	for actor in actors:
		actor.slide_bars()

func commit_action():
	if needs_target:
		if current_action == 'fight':
			actors[current_actor].me.fight(current_target.me)
			actors[current_actor].me.spend_speed()
			current_target = null
			current_action = null
			needs_target = false
			next_turn()
	else:
		msg.say("Select a target")

	for hero in heroes.get_heroes():
		hero.draw_battler()
	for monster in monsters.get_monsters():
		monster.draw_battler()


func set_target(target):
	current_target = target
	needs_target = false

func new_round():
	build_actors()
	for actor in actors:
		actor.me.restore_speed()
		actor.draw_battler()
	current_actor = 0
	_initiative()
	if actors[current_actor].me.has_method('get_xp_to_level'):
		is_hero = true
	else:
		is_hero = false
	show_combat_options()
	if not is_hero:
		next_turn()

func next_turn():
	if actors[current_actor].me.current_speed < 8:
		actors.remove(current_actor)
	current_actor += 1
	if current_actor > actors.size()-1:
		if actors.size() <=1:
			new_round()
		else:
			current_actor = 0
	msg.say("It is now "+actors[current_actor].me.get_name()+"'s turn to act")
	if actors[current_actor].me.has_method('get_xp_to_level'):
		is_hero = true
	else:
		is_hero = false
	show_combat_options()

func build_actors():
	#create actors list
	actors = []
	for hero in heroes.get_heroes():
		actors.append(hero)
	for monster in monsters.get_monsters():
		actors.append(monster)

func pre_battle():
	for actor in actors:
		actor.me.current_speed = actor.me.get_speed() + int(round(rand_range(1,8)))
		actor.draw_battler()
	_initiative()
	msg.say("It is now "+actors[current_actor].me.get_name()+"'s turn to act")


func show_combat_options():
	if is_hero:
		combat.get_node('fight').set_disabled(false)
		combat.get_node('block').set_disabled(false)
	else:
		hide_combat_options()

func hide_combat_options():
	for button in combat.get_children():
		button.set_disabled(true)

func _initiative():
	#sort list by Speed
	actors.sort_custom(self,"_sort_by_speed")
	msg.say("\n[color=red]Order of initiative[/color]")
	for actor in actors:
		msg.say(actor.me.get_name())

func _sort_by_speed(a,b):
	if a.me.current_speed > b.me.current_speed:
		return true
	else:
		return false



func _on_fight_pressed():
	current_action = "fight"
	needs_target = true
	commit_action()

func _on_block_pressed():
	current_action = "block"
	commit_action()
