
extends PanelContainer

const ACTIVE_COLOR = Color(0.31,0.91,0.26)
const INACTIVE_COLOR = Color(1.0,1.0,1.0)

onready var msg = get_node('/root/Battle/box/battle/message/msgbox')

onready var box = get_node('box')
onready var stats = box.get_node('box')
onready var hpmp = stats.get_node('hpmp')
onready var speedbox = stats.get_node('speed')

onready var name = box.get_node('status')
onready var HP_label = hpmp.get_node('HP/box/value')
onready var HP_bar = hpmp.get_node('HP/box/bar')
onready var MP_label = hpmp.get_node('MP/box/value')
onready var MP_bar = hpmp.get_node('MP/box/bar')
onready var speed = speedbox.get_node('box/value')
onready var action_timer = get_node('action_timer')
var action_time = 2		#seconds an action takes
var me


func setup():
	me.restore_full()
	me.restore_speed()
	setup_bars()
	draw_battler()

func draw_name():
	name.set_text(me.get_name())


func draw_HP():
	HP_label.set_text(str(me.current_HP)+"/"+str(me.get_HP()))
func draw_MP():
	MP_label.set_text(str(me.current_MP)+"/"+str(me.get_MP()))

func slide_bars():
	slide_HP()
	slide_MP()

func slide_HP():
	var value = HP_bar.get_value()
	if value != me.current_HP:
		var diff = me.current_HP - value
		var dir = sign(diff)
		HP_bar.set_value(value + (1*dir))

func slide_MP():
	var value = MP_bar.get_value()
	if value != me.current_MP:
		var diff = me.current_MP - value
		var dir = sign(diff)
		MP_bar.set_value(value + (1*dir))


func draw_speed():
	speed.set_text(str(me.current_speed))

func setup_bars():
	set_bar_max()
	HP_bar.set_value(me.current_HP)
	MP_bar.set_value(me.current_MP)
	
func set_bar_max():
	HP_bar.set_max(me.get_HP())
	MP_bar.set_max(me.get_MP())

func draw_battler():
	draw_name()
	draw_HP()
	draw_MP()
	draw_speed()

func activate_battler():
	name.set('custom_colors/font_color',ACTIVE_COLOR)

func deactivate_battler():
	name.set('custom_colors/font_color',INACTIVE_COLOR)

func begin_attack():
	action_timer.set_wait_time(action_time)
	action_timer.start()

func fight(target):
	var attacker = me.get_name()
	var defender = target.get_name()
	var attack = me.fight(target)
	var dmg = str(attack[0])
	var txt = ""
	if attack[1] or attack[2]:
		txt = "The "+attacker+" missed "+defender
	elif attack[3]:
		txt = "[color=red]The "+attacker+" deals a CRITICAL HIT to "+defender+" for "+dmg+" damage!!![/color]"
	else:
		txt = "The "+attacker+" hits "+defender+" for "+dmg+" damage!"
	msg.say(txt)
	target.receive_attack(attack)

func monster_pre_action():
	action_timer.start()
	
func _on_status_toggled( pressed ):
	if get_node('/root/Battle').needs_target:
		print("targeting "+me.get_name())
		get_node('/root/Battle').set_target(self)
		get_node('/root/Battle').commit_action()
		name.set_pressed(false)
	else:
		get_parent()._on_hero_status_toggled(pressed,self)


func _on_Timer_timeout():
	get_node('/root/Battle').monster_post_action()
	action_timer.stop()
