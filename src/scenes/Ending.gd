extends Node2D

var can_play = true

func _ready():
	if get_node('../../..').has_gift:
		print('Soy una nina con juguete')
		EventsMgr.emit_signal('play_requested','VO/Main', 'FelizCumple')
		yield(get_tree().create_timer(2.4), 'timeout')
		EventsMgr.emit_signal('play_requested','VO/Girl', 'Gracias')
	else:
		print('Mama, donde estan los juguetes?')
		EventsMgr.emit_signal('play_requested','VO/Main', 'Sad')
		yield(get_tree().create_timer(2.4), 'timeout')
		EventsMgr.emit_signal('play_requested','VO/Girl', 'TeQuiero')
