
extends Node

func number( N ):
	assert str(N).is_valid_integer()
	var string = str(N)
	if string.length() > 3:
		for i in range(string.length()-3,0,-3):
			print(i)
			string = string.insert(i,',')

	return string
	


