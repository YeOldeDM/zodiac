
extends Node

class Party:
	var actors
	
	func _init(actors=[]):
		self.actors = actors
	
	func add_actor(actor):
		self.actors.append(actor)
	
	func remove_actor(actor):
		self.actors.remove(actor)




