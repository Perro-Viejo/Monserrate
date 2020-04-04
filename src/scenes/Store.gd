extends Node2D

var current_funds 

func _ready():
	
	current_funds = get_node('../../..').funds
	print('tienes $', current_funds)
	
	$Gift_01.connect('button_down', self, '_on_button_down', ['El Mostro', 5000])
	$Gift_02.connect('button_down', self, '_on_button_down', ['El Oso', 15000])
	$Gift_03.connect('button_down', self, '_on_button_down', ['La Micki', 30000])

func _on_button_down(gift, cost):
	if current_funds >= cost:
		print('Tenga su mamarracho')
		match gift:
			'El Mostro':
				$Gift_01.hide()
			'El Oso':
				$Gift_02.hide()
			'La Micki':
				$Gift_03.hide()
	else:
		print (gift, ' cuesta $', cost, '. No le alcanza mi chan :(')
