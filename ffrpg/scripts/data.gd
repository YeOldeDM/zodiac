
extends Node

func _invalid_file(path):
	OS.alert("\nINVALID FILE: "+path, "Bad File Error")

func _saved_file(path):
	OS.alert("Saved data to:  "+path, "File Saved Successfully!")
	
func save_monster(monster):
	var data = monster.get_package()
	var save = File.new()
	var path = 'res://data/monsters/'+monster.get_name()+'.monster'
	save.open(path,File.WRITE)
	save.store_line(data.to_json())
	_saved_file(path)
	save.close()

func load_monster(path):
	var data = {}
	var file = File.new()
	if file.file_exists(path):
		file.open(path,File.READ)
		while !file.eof_reached():
			data.parse_json(file.get_line())
	else:
		_invalid_file(path)
		file.close()
		return null
	file.close()
	var monster = dict2inst(data['monster'])
	return monster

func save_hero(hero):
	#grab data
	var data = hero.get_package()
	#init save file
	var save = File.new()
	var path = 'res://data/heroes/'+hero.get_name()+'.hero'
	save.open(path,File.WRITE)
	#save data
	save.store_line(data.to_json())
	#close file
	_saved_file(path)
	save.close()

func load_hero(path):
	#set up
	var data = {}
	var file = File.new()
	#try path and parse data
	if file.file_exists(path):
		prints("Found Hero file",path)
		file.open(path,File.READ)
		while !file.eof_reached():
			data.parse_json(file.get_line())
	else:
		_invalid_file(path)
		file.close()
		return null
	file.close()
	#Hero Factory
	var hero = dict2inst(data['hero'])
	if 'weapon' in data:
		hero.equip_weapon(dict2inst(data['weapon']))
	if 'armor' in data:
		hero.equip_armor(dict2inst(data['armor']))
	if 'guard' in data:
		hero.equip_guard(dict2inst(data['guard']))
	return hero
