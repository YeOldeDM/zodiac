
extends PanelContainer

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

func draw_speed():
	speed.set_text(str(me.current_speed))

func setup_bars():
	HP_bar.set_max(me.get_HP())
	HP_bar.set_value(me.current_HP)
	MP_bar.set_max(me.get_MP())
	MP_bar.set_value(me.current_MP)
	

func draw_battler():
	draw_name()
	draw_HP()
	draw_MP()
	draw_speed()

func _on_status_toggled( pressed ):
	get_parent()._on_hero_status_toggled(pressed,self)
