
extends Control

# Sheet panel
onready var sheet = get_node('SheetPopup')

# Children
onready var name = get_node('box/Name')

onready var hpmp = get_node('box/HPMP')

onready var hp_label = hpmp.get_node('box/labels/HP')
onready var mp_label = hpmp.get_node('box/labels/MP')







onready var hp_bar = hpmp.get_node('box/bars/HP')
onready var mp_bar = hpmp.get_node('box/bars/MP')

# Character Data
var data

# Load a Hero into the Battler
func set_hero(name):
	var hero = Data.load_hero(name)
	if hero extends Hero.Hero:
		data = hero
		sheet.data = hero
		init(true)
	else:
		OS.alert('Could not find the file for "'+hero+'"')

# Load a Monster into the Battler
func set_monster(name):
	var monster = Data.load_monster(name)
	if monster extends Monster.Monster:
		data = monster
		sheet.data = monster
		init()
	else:
		OS.alert('Could not find the file for "'+monster+'"')

# Initialize Battler
func init(restore=false):
	assert data
	if restore:
		data.full_restore()
	draw_name()
	draw_HP()
	draw_MP()

# Draw Battler name
func draw_name():
	name.set_text(data.name)

# Draw HP Bar/Text
func draw_HP():
	var HP = data.HP
	var maxHP = data.get_max_HP()
	var txt = "HP "+Format.number(HP)+"/"+Format.number(maxHP)
	hp_label.set_text(txt)
	
	hp_bar.set_max(maxHP)
	hp_bar.set_value(HP)

# Draw MP Bar/Text
func draw_MP():
	var MP = data.MP
	var maxMP = data.get_max_MP()
	var txt = "MP "+Format.number(MP)+"/"+Format.number(maxMP)
	mp_label.set_text(txt)
	
	mp_bar.set_max(maxMP)
	mp_bar.set_value(MP)

# Pressing the Nametag
func _on_Name_pressed():
	sheet.popup()


func _ready():
	set_hero("Fess")
	