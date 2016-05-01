
extends Node

#damage multipliers for elemental weakness/resistance
	#0=weakness: take double damage
	#1=normal: take normal damage
	#2=resist: take half damage
	#3=immune: take no damage
	#4=absorb: heal half damage
	#5=absorb+: heal all damage
var element_effect = [
	2.0,1.0,0.5,0.0,-0.5,-1.0]

# weapon attack/magic attack by [point_value][lvl]
var weapon_attack_chart = [
	[0,0,0,0,10,20,30,40,50,70],
	[10,15,20,30,40,50,60,70,80,100],
	[15,25,30,40,55,70,85,100,115,150],
	[20,30,40,50,70,90,110,130,150,200],
	[30,45,60,80,100,120,140,160,180,230]
		]

# attack die type (1dx) based on point value
var weapon_attack_dice = [6,8,8,8,10]

#bonuses conveyed to stats from weapon abilities, [base,inc/lvl]
var weapon_ability_stat_bonus = {
	'magic':	[3,2],
	'agility':	[3,2],
	'vitality':	[2,1],
	'spirit':	[2,1]
	}
# armor HP/MP bonus by [type][lvl][HP/MP]
var armor_chart = [
	[
		[10,4],[15,6],[25,8],[40,12],[50,20],[65,25],[80,30],[100,40],[125,50],[175,65]
		],
	[
		[20,2],[30,3],[50,4],[80,6],[100,10],[130,14],[160,18],[200,20],[250,25],[350,35]
		],
	[
		[35,0],[50,0],[75,0],[120,0],[150,0],[200,0],[250,0],[300,0],[375,0],[500,0]
		]
			]

# guard evade by lvl
var guard_chart = [2,4,6,8,10,12,14,16,18,23]



#	TECH CHARTS

# tech MP cost by [type][lvl]
var tech_MP_cost = [
	[1,2,4,10,17,23,33,45,58],
	[1,3,6,12,19,26,37,49,63],
	[1,4,8,14,21,29,41,53,68]
	]

var charge_power_cost = [
	[9,9,11,13,15,17,19,21,23],
	[9,10,12,14,16,18,20,22,24],
	[10.11,13,15,17,19,21,23,25]
	]

# tech point cost by [lvl]
var tech_point_cost = [8,15,30,60,125,250]

var power_attack = [
	[1,1],
	[1,1.5],
	[2,1.5],
	[2,2],
	[3,2],
	[3,2.5]
	]

var healing = [
	[20,30,40,0.5],
	[50,60,70,0.5],
	[80,90,100,1.0],
	[120,130,140,1.0],
	[140,160,180,1.5],
	[200,220,250,2.0]
	]

var command_skills = [
	"Capture",
	"Coin Toss",
	"Chakra",
	"Clone",
	"Deathblow",
	"Dice",
	"Draw Out",
	"Health",
	"Jump",
	"Kick",
	"Manipulate",
	"Mimic",
	"Mix",
	"Morph",
	"Peep",
	"Peril",
	"Rage",
	"Runic",
	"Slots",
	"Steal",
	"Throw",
	"Wish",
	"X-Magic"
	]

var support_skills = [
	"Attack Up",
	"Chemist",
	"Concentrate",
	"Counter",
	"Cover",
	"Flight",
	"Lucky",
	"Magic Up",
	"Mental Strength",
	"Natural Resistance",
	"Quickness",
	"Secret Hunt",
	"Toughness",
	"Weapon Guard"
	]


