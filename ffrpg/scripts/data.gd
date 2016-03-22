
extends Node

func save_monster(monster):
	var data = monster.get_package()
	var save = File.new()
	var path = 'res://data/monsters/'+monster.get_name()+'.zd'
	save.open(path,File.WRITE)
	save.store_line(data.to_json())
	print("Successfully saved Monster:  "+monster.get_name())
	save.close()

func load_monster(name):
	var data = {}
	var file = File.new()
	var path = 'res://data/monsters/'+name+'.zd'
	if file.file_exists(path):
		file.open(path,File.READ)
		while !file.eof_reached():
			data.parse_json(file.get_line())
	else:
		print("\nINVALID MONSTER NAME "+name+"\n")
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
	var path = 'res://data/heroes/'+hero.get_name()+'.zd'
	save.open(path,File.WRITE)
	#save data
	save.store_line(data.to_json())
	#close file
	print("Successfully saved to:  ",path)
	save.close()

func load_hero(name):
	#set up
	var data = {}
	var file = File.new()
	var path = 'res://data/heroes/'+name+'.zd'
	#try path and parse data
	if file.file_exists(path):
		prints("Found Hero file",path)
		file.open(path,File.READ)
		while !file.eof_reached():
			data.parse_json(file.get_line())
	else:
		print("\nINVALID CHARACTER NAME  "+name+"\n")
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
