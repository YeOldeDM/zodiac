
extends Node

class Battler:
	var party
	var monster_party
	
	var turn = 0
	var tick = 0
	
	var order_list = []
	
	func _init(party,monster_party):
		self.party = party
		self.monster_party = monster_party
	



