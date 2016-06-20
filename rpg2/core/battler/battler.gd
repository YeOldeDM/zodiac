
extends Control

onready var sheet = get_node('SheetPopup')

onready var name = get_node('box/Name')
onready var hpmp = get_node('box/HPMP')
onready var hp_label = hpmp.get_node('box/labels/HP')
onready var mp_label = hpmp.get_node('box/labels/MP')
onready var hp_bar = hpmp.get_node('box/bars/HP')
onready var mp_bar = hpmp.get_node('box/bars/MP')

var data

func set_hero(name):
	var hero = Data.load_hero(name)
	if hero extends Hero.Hero:
		data = hero
		init()
	else:
		OS.alert('Could not find the file for "'+hero+'"')

func init():
	assert data
	data.full_restore()
	draw_name()
	draw_HP()
	draw_MP()

func draw_name():
	name.set_text(data.name)

func draw_HP():
	var HP = data.HP
	var maxHP = data.get_max_HP()
	var txt = "HP "+str(HP)+"/"+str(maxHP)
	hp_label.set_text(txt)
	
	hp_bar.set_max(maxHP)
	hp_bar.set_value(HP)
	
func draw_MP():
	var MP = data.MP
	var maxMP = data.get_max_MP()
	var txt = "MP "+str(MP)+"/"+str(maxMP)
	mp_label.set_text(txt)
	
	mp_bar.set_max(maxMP)
	mp_bar.set_value(MP)



func _ready():
	set_hero("Fess")


func _on_Name_pressed():
	sheet.popup()
