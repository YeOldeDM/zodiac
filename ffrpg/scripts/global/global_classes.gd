
extends Node

class Battle:
	#handles the mechanics of combat


	var heroes		#a list of Actor Battlers
	var monsters		#a list of Monster Battlers
	
	var battle_round	#current combat round
	var battle_tick		#current combat tick
	var battle_turn		#current turn in the init stack
	
	var victory_event
	var defeat_event



	func _init(heroes,monsters,victory,defeat):
		self.heroes = heroes
		self.monsters = monsters
		self.vicory_event = victory
		self.defeat_event = defeat
		setup()



	func setup():
		pass
		
	func victory():
		#return true if victory conditions are met
		return false
		
	func defeat():
		#return true if Party failure conditions are met
		return false



	func pre_turn():
		#rund before a new round begins
		self.battle_turn += 1
		#do stuff..
		#..to trigger self.post_turn()

	func post_turn():
		#run at the end of a turn
		#go to next turn or next tick
		var has_active_actors = false
		if has_active_actors:
			pre_turn()
		else:
			post_tick()



	func pre_tick():
		#ran before a new tick begins
		#reset the turn cycle and go to next turn
		self.battle_tick += 1
		self.battle_turn = -1
		self._pre_turn()
	
	func post_tick():
		#ran at the end of a tick
		#either start a new tick, or a new round
		if self.heroes.has_active() or self.monsters.has_active():
			self.pre_tick()
		else:
			self.post_round()



	func pre_round():
		#ran before a new round begins
		#reset tick/turn and begin new tick
		self.battle_round += 1
		self.battle_tick = 0
		self.pre_tick()
		
	func post_round():
		#ran after the current round is finished
		
		#check for victory first
		if victory():
			#self._process_victory()
			pass
		
		#check for defeat
		elif defeat():
			#self._process_defeat()
			pass
		
		#or begin a new round and continue
		else:
			pre_round()	#start a new round






class Battler:
	#A container for the battle aspect of an Actor or Monster
	var team		#the Party/Troop object we belong to
	var owner		#the Actor/Monster we represent
	
	var speed = 10
	
	func _init(team,owner):
		self.team = team
		self.owner = owner
	
	func is_dead():
		return false
	
	func is_active():
		#true if current speed >= 8 and not dead
		if !self.is_dead && self.speed >= 8:
			return true
		return false


class Party:
	#handles the mechanics of a group of Actors or Monsters
	var team
	
	func _init(team):
		self.team = team

	func get_team():
		return self.team
	
	func is_defeated():
		#true if all party members are dead
		for member in self.team:
			if !member.is_dead():
				return false
		return true

	func has_active():
		#return true if the Party has active members
		#(not dead and not below 8 speed)
		for member in self.team:
			if !member.is_active():
				return true
		return false
				
