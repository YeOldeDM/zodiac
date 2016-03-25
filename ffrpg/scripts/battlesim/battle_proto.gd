
extends Container

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')

onready var heroes = get_node('box/heroes')
onready var monsters = get_node('box/battle/monsters/box/list')
onready var combat = get_node('box/options/actions/combat')

var all_actors = []
var actors = []

var current_actor = null
var current_target = null
var current_action = null

var current_turn = 0
var combat_round = 1
var tick = 1

var needs_target = true

var is_hero = false	#is the current actor a hero?

func _ready():
	randomize()
	build_actors()
	pre_battle()

	set_process(true)

func _process(delta):
	for actor in actors:
		actor.slide_bars()

func commit_action():
	if not needs_target:
		if current_action == 'fight':
			current_actor.fight(current_target.me)
			current_actor.me.spend_speed()
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
	combat_round += 1
	build_actors()
	for actor in actors:
		actor.me.restore_speed()
		actor.draw_battler()
	current_turn = 0
	_initiative()
	_check_is_hero()
	show_combat_options()
	if not is_hero:
		next_turn()

func new_tick():
	tick += 1
	msg.say("\n[color=red]New Tick[/color] "+str(tick))
	finish_actors()
	_initiative()
	current_turn = 0
	current_actor = actors[current_turn]
	_check_is_hero()
	if not is_hero:
		_monster_action()
		next_turn()
	show_combat_options()
	msg.say("\nIt is now "+current_actor.me.get_name()+"'s turn to act")

func _check_is_hero():
	if current_actor.me.has_method('get_xp_to_level'):
		is_hero = true
		print("hero")
	else:
		is_hero = false
		print("monster")

func finish_actors():
	#remove actor from action list
	for i in range(actors.size()-1):
		if actors[i].me.current_speed < 8:
			actors.remove(i)
			

func next_turn():
	if actors.empty():
		new_round()
	current_turn += 1
	print("\n turn "+str(current_turn)+"\n")
	if current_turn > actors.size()-1:
		new_tick()
	else:
		current_actor = actors[current_turn]
		msg.say("\nIt is now "+current_actor.me.get_name()+"'s turn to act")
		_check_is_hero()
		show_combat_options()
		if not is_hero:
			_monster_action()
			next_turn()
	
func build_actors():
	#create actors list
	actors = []
	for hero in heroes.get_heroes():
		actors.append(hero)
		all_actors.append(hero)
	for monster in monsters.get_monsters():
		actors.append(monster)
		all_actors.append(monster)
	print("WE GOT "+str(actors.size())+" ACTORS")

func _monster_action():
	current_actor.me.spend_speed()
	msg.say("The "+current_actor.me.get_name()+" wiggles around.")
	current_actor.draw_battler()

func pre_battle():
	for actor in actors:
		actor.me.current_speed = actor.me.get_speed() + int(round(rand_range(1,8)))
		actor.draw_battler()
	_initiative()
	current_actor = actors[0]
	msg.say("\nIt is now "+current_actor.me.get_name()+"'s turn to act")
	_check_is_hero()
	if not is_hero:
		_monster_action()
		next_turn()
	show_combat_options()

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
	Roll.initiative(actors)
	msg.say("\n[color=red]Round[/color] "+str(combat_round))
	say_initiative()

func say_initiative():
	msg.say("\n[color=red]Order of initiative[/color]")
	for actor in actors:
		msg.say(actor.me.get_name()+" ("+str(actor.me.current_speed)+")")
	msg.newline()


func _on_fight_pressed():
	current_action = "fight"
	needs_target = true
	commit_action()

func _on_block_pressed():
	current_action = "block"
	commit_action()
