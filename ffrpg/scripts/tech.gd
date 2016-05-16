
extends Node

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