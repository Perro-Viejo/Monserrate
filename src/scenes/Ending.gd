extends Node2D


func _ready():
	if get_node('../../..').has_gift:
		print('Soy una nina con juguete')
	else:
		print('Mama, donde estan los juguetes?')
