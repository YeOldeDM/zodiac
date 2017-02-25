
extends Node

const HERO_DATA_PATH = 'res://data/hero/'
const MONSTER_DATA_PATH = 'res://data/monster/'
const WEAPON_DATA_PATH = 'res://data/equipment/weapon/'
const ARMOR_DATA_PATH = 'res://data/equipment/armor/'
const GUARD_DATA_PATH = 'res://data/equipment/guard/'
const ITEM_DATA_PATH = 'res://data/item/'
const TECH_DATA_PATH = 'res://data/tech/'


# Get value from ConfigFile file, section and key
# if it exists..
func get_value(file, section, key):
	assert file
	if file.has_section_key(section,key):
		return file.get_value(section,key)
	print(file.get_value('INFO','name')+": No value found for "+section+":"+key)
	return null


# SAVE MONSTER TO .monster FILE
func save_monster( actor, filename=null ):
	var file = ConfigFile.new()
	if filename == null:
		filename = actor.name.replace(' ','_')
	else: filename = filename.replace(' ','_')	#replace any spaces with underscores
	var path = Data.MONSTER_DATA_PATH+filename+'.monster'
	
	# Set Info
	for entry in [
					['name', actor.name],
					['boss', actor.is_boss],
					]:
		file.set_value("INFO", entry[0], entry[1])
	
	# Set Vitals
	for entry in [
					['level', actor.level],
					['HP', actor.HP],
					['MP', actor.MP],
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
	var ext = '.monster'
	if filename.ends_with(ext):
		ext = ''
	var path = Data.MONSTER_DATA_PATH+filename+ext
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if loaded == OK:
		var name = get_value(file,"INFO", 'name')
		var boss = get_value(file,"INFO", 'boss')
		var level = get_value(file,"VITALS", 'level')
		var HP = get_value(file,"VITALS", 'HP')
		var MP = get_value(file,"VITALS", 'MP')
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
		return null


		
		
		
		
# SAVE HERO TO .hero FILE
func save_hero( actor, filename=null ):
	var file = ConfigFile.new()
	if filename == null:
		filename = actor.name.replace(' ','_')
	else: filename = filename.replace(' ','_')	#replace any spaces with underscores
	var path = Data.HERO_DATA_PATH+filename+'.hero'
	
	# Set Info
	for entry in [
					['name', actor.name],
					['job', actor.job],
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
	var ext = '.hero'
	if filename.ends_with(ext):
		ext = ''
	var path = Data.HERO_DATA_PATH+filename+ext
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if loaded == OK:
		var name = file.get_value("INFO", 'name')
		var job = file.get_value("INFO", 'job')
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
		
		var hero = Hero.Hero.new(name,job,level,XP,HP,MP,base_stats,stat_weights,\
						command,support,elements,status)
		return hero
	else:
		OS.alert("ERROR loading path "+path)
		return null
		


func save_weapon( weapon, filename=null ):
	if filename == null:
		filename = weapon.name.replace(' ','_')
	filename = filename.replace(' ','_')
	var path = 'res://data/equipment/weapon/'+filename+'.weapon'
	var file = ConfigFile.new()
	file.set_value("INFO", 'name', weapon.name)
	file.set_value("INFO", 'set', weapon.set)
	file.set_value("INFO", 'level', weapon.level)
	file.set_value("INFO", 'cost', weapon.cost)
	file.set_value("ATTACK", 'attack_level', weapon.power_setting[0])
	file.set_value("ATTACK", 'magic_level', weapon.power_setting[1])
	file.set_value("ATTACK", 'AP_bonus', weapon.AP)
	file.set_value("ATTACK", 'MAP_bonus', weapon.MAP)
	file.set_value("ATTACK", 'attack_die', weapon.power_die)
	file.set_value("ATTACK", 'magic_die', weapon.magic_die)
	file.set_value("MISC", 'specials', weapon.specials)
	file.set_value("MISC", 'elements', weapon.elements)
	var saved = file.save(path)
	if !saved==OK:
		OS.alert("an error occured while trying to save "+path)
	return file



func load_weapon( filename ):
	filename = filename.replace(' ','_')
	var ext = '.weapon'
	if filename.ends_with(ext):
		ext = ''
	var path = Data.WEAPON_DATA_PATH+filename+ext
	
	var file = ConfigFile.new()
	var loaded = file.load(path)
	if !loaded == OK:
		OS.alert("an error occured while trying to load "+path)
	var name = file.get_value("INFO", 'name')
	var set = file.get_value("INFO", 'set')
	var level = file.get_value("INFO", 'level')
	var cost = file.get_value("INFO", 'cost')
	var power_setting = [file.get_value("ATTACK", 'attack_level'),
						file.get_value("ATTACK", 'magic_level')]
	var AP = file.get_value("ATTACK", 'AP_bonus')
	var MAP = file.get_value("ATTACK", 'MAP_bonus')
	var pdie = file.get_value("ATTACK", 'attack_die')
	var mdie = file.get_value("ATTACK", 'magic_die')
	var specials = file.get_value("MISC", 'specials')
	var elements = file.get_value("MISC", 'elements')
	var weapon = Equipment.Weapon.new(name, set, level, cost, power_setting, AP, MAP, pdie, mdie, specials, elements)
	return weapon