
extends Node

func save_hero( actor, filename=null ):
	var file = ConfigFile.new()
	if filename == null:
		filename = actor.name.replace(' ','_')
	else: filename = filename.replace(' ','_')	#replace any spaces with underscores
	var path = 'res://data/hero/'+filename+'.hero'
	
	# Set Info
	for entry in [
					['name', actor.name],
					]:
		file.set_value("INFO", entry[0], entry[1])
	
	# Set Vitals
	for entry in [
					['level', actor.level],
					['XP', actor.XP],
					['HP', actor.HP],
					['MP', actor.MP],
					]:
		file.set_value("VITALS", entry[0], entry[1])

	# Set Stats
	var stats = actor.base_stats
	for entry in ['strength', 'magic',
				'vitality', 'spirit', 'agility']:
		file.set_value("STATS", entry, stats[entry])
	# Set Stat Weights
	var stats = actor.stat_weights
	for entry in ['strength', 'magic',
				'vitality', 'spirit', 'agility']:
		file.set_value("STAT_WEIGHTS", entry, stats[entry])
	# Set Skills
	for entry in [['command', actor.command_skill],
					['support', actor.support_skill]]:
		file.set_value("SKILLS", entry[0], entry[1])
	# Set Conditions
	file.set_value("CONDITIONS", 'elemental_affinity', actor.elemental_affinity)
	file.set_value("CONDITIONS", 'status_effects', actor.status_effects)
	
	#Save the file, and return it
	var saved = file.save(path)
	if saved == OK:
		return file

func load_hero( filename ):
	filename = filename.replace(' ','_')
	var path = 'res://data/hero/'+filename+'.hero'
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if loaded == OK:
		var name = file.get_value("INFO", 'name')
		var level = file.get_value("VITALS", 'level')
		var XP = file.get_value("VITALS", 'XP')
		var HP = file.get_value("VITALS", 'HP')
		var MP = file.get_value("VITALS", 'MP')
		var base_stats = {}
		var stat_weights = {}
		for stat in file.get_section_keys("STATS"):
			base_stats[stat] = file.get_value("STATS",stat)
		for stat in file.get_section_keys("STAT_WEIGHTS"):
			stat_weights[stat] = file.get_value("STATS",stat)
		var command = file.get_value("SKILLS", 'command')
		var support = file.get_value("SKILLS", 'support')
		var elements = file.get_value("CONDITIONS", 'elemental_affinity')
		var status = file.get_value("CONDITIONS", 'status_effects')
		
		var hero = Hero.Hero.new(name,level,XP,HP,MP,base_stats,stat_weights,\
						command,support,elements,status)
		return hero
	else:
		print("ERROR loading path ",path)
	