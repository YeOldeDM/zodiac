
extends Node

# Get value from ConfigFile file, section and key
# if it exists..
func get_value(file, section, key):
	assert file
	if file.has_section_key(section,key):
		return file.get_value(section,key)
	print("No value found for "+section+":"+key)
	return null


# SAVE MONSTER TO .monster FILE
func save_monster( actor, filename=null ):
	var file = ConfigFile.new()
	if filename == null:
		filename = actor.name.replace(' ','_')
	else: filename = filename.replace(' ','_')	#replace any spaces with underscores
	var path = 'res://data/monster/'+filename+'.monster'
	
	# Set Info
	for entry in [
					['name', actor.name],
					]:
		file.set_value("INFO", entry[0], entry[1])
	
	# Set Vitals
	for entry in [
					['level', actor.level],
					['HP', actor.HP],
					['MP', actor.MP],
					['boss', actor.is_boss],
					['pdie', actor.physical_die],
					['mdie', actor.magical_die],
					]:
		file.set_value("VITALS", entry[0], entry[1])

	# Set Stats
	var stats = actor.base_stats
	for entry in ['strength', 'magic',
				'vitality', 'spirit', 'agility']:
		file.set_value("STATS", entry, stats[entry])

	# Set Conditions
	file.set_value("CONDITIONS", 'elemental_affinity', actor.elemental_affinity)
	file.set_value("CONDITIONS", 'status_effects', actor.status_effects)
	
	#Save the file, and return it
	var saved = file.save(path)
	if saved == OK:
		return file

		
# LOAD MONSTER FROM .monster FILE
func load_monster( filename ):
	filename = filename.replace(' ','_')
	var path = 'res://data/monster/'+filename+'.monster'
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if loaded == OK:
		var name = get_value(file,"INFO", 'name')
		var level = get_value(file,"VITALS", 'level')
		var HP = get_value(file,"VITALS", 'HP')
		var MP = get_value(file,"VITALS", 'MP')
		var boss = get_value(file,"VITALS", 'boss')
		var pdie = get_value(file,"VITALS", 'pdie')
		var mdie = get_value(file,"VITALS", 'mdie')

		var base_stats = {}
		for stat in file.get_section_keys("STATS"):
			base_stats[stat] = get_value(file,"STATS",stat)
		var elements = get_value(file,"CONDITIONS", 'elemental_affinity')
		var status = get_value(file,"CONDITIONS", 'status_effects')
		
		var monster = Monster.Monster.new(name,level,boss,pdie,mdie,base_stats,elements,status)
		
		monster.set('HP', HP)
		monster.set('MP', MP)
		return monster
	else:
		OS.alert("ERROR loading path "+path)


		
		
		
		
# SAVE HERO TO .hero FILE
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


# LOAD HERO FROM .hero FILE
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
		OS.alert("ERROR loading path "+path)
	