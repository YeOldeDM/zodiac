
extends Node

class MonsterPower:
	var owner
	var name
	var level
	
	var params
	
	func _init(owner,name="Power",level=1,params=[]):
		self.owner = owner
		self.name = name
		self.level = level
		self.params = params

#Lvl X Monster Powers
func ExceptionalStats(owner,L=1):
	return MonsterPower(owner,"Exeptional Stats("+str(L)+")",L,\
				['stat_points',10*L])

func FinalAttack(owner,power,L=1,sacrifice=false):
	return MonsterPower(owner,"Final Attack",L,\
					['final_attack',sacrifice,power,L+1])

#func CombinationAttack
#func MultipleParts

#Lvl 0 Monster Powers
func Undead(owner):
	return MonsterPower(owner,"Undead",0,['undead'])

func UnusualDefense(owner,magical=false,alternate=0):
	#magical=false: 1/2dmg vs physical / 2xdmg vs magic
	#magical=true:  1/2dmg vs magic / 2xdmg vs physical
	#alternate=true: defense swaps every 1d2 rounds
	var name = "Unusual Defense(Physical)"
	if magical==true:
		name = "Unusual Defense(Magical)"
	if alternate==1:
		name += " -Alternate"
	return MonsterPower(owner,name,0,\
					['unusual_defense',magical,alternate])

func Weakness(owner,element):
	var name = "Elemental Weakness: "+element.capitalize()
	return MonsterPower(owner,name,-1,['element',element,0])

#Lvl 1 Monster Powers
func Flight(owner):
	return MonsterPower(owner,"Flight",1,['flight'])

#func ItemUse(owner,ether=false):


func LesserCounterattack(owner):
	return MonsterPower(owner,"Lesser Counterattack",1,\
						['counterattack',0.1])

func LesserMagicalCounterattack(owner):
	return MonsterPower(owner,"Lesser Magical Counterattack",1,\
						['magic_counterattack',0.1])

#func CommandSkill

func Resistance(owner,element):
	var name = "Elemental Resistance: "+element.capitalize()
	return MonsterPower(owner,name,1,['element',element,2])

func WeakStatusTouch(owner,status):
	var name = "Weak Status Touch: "+status.capitalize()
	return MonsterPower(owner,name,1,['status_touch',status,2])

#Lvl 2 Monster Powers

func Agile(owner):
	return MonsterPower(owner,"Agile",2,['agile'])

func CallMinions(owner,minion):
	var name = "Call Minions: "+minion.get_name()
	return MonsterPower(owner,name,2,['call_minions',minion])

func Immunity(owner,element):
	var name = "Elemental Immunity: "+element.capitalize()
	return MonsterPower(owner,name,2,['element',element,3])

func WeakRegeneration(owner):
	return MonsterPower(owner,"Weak Regeneration",2,\
						['hp_regen',0.05])

#Lvl 3 Monster Powers

func ControlledDefense(owner,magical=false):
	var name = "Controlled Defense: "
	if magical==true:
		name += "Magical"
	else:
		name += "Physical"
	return MonsterPower(owner,name,3,['unusual_defense',magical,2])

func Counterattack(owner):
	return MonserPower(owner,"Counterattack",3,['counterattack',0.25])

func MagicalCounterattack(owner):
	return MonserPower(owner,"Magical Counterattack",3,['magic_counterattack',0.25])

func LesserAbsorbancy(owner,element):
	var name = "Lesser Elemental Absorbancy: "+element.capitalize()
	return MonsterPower(owner,name,3,['element',element,4])

#func MajorItemUse



class Tech:
	var name
	var level
	var TP_cost
	var cast_cost
	var cast_method
	
	func _init(name="Tech",level=1, TP_cost=null,\
			cast_cost=null,cast_method=0):
		self.name = name
		self.level = level
		if TP_cost == null:
			self.TP_cost = Chart.tech_point_cost[level]