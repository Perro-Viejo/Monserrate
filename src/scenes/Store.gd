extends Node2D

var current_funds 
var buying_attempts = 0
var can_play = true

func _ready():
	if DataMgr.data_get(ConstantsMgr.DataIds.FUNDS):
		current_funds = DataMgr.data_get(ConstantsMgr.DataIds.FUNDS)
	else:
		current_funds = 2000
	print('Hay %d lucas en la marrana' % current_funds)
	
	EventsMgr.emit_signal('play_requested', 'BG', 'Store')

	EventsMgr.emit_signal('play_requested', 'VO/Seller', 'Greet')
	can_play = false
	EventsMgr.connect('stream_finished', self, '_on_stream_finished')
	
	$Gift_01.connect('button_down', self, '_on_button_down', ['El Mostro', 5000])
	$Gift_02.connect('button_down', self, '_on_button_down', ['El Oso', 15000])
	$Gift_03.connect('button_down', self, '_on_button_down', ['La Micki', 30000])
	
	$Gift_01.connect('mouse_entered', self, 'toggle_price', [ $Price_01 ])
	$Gift_01.connect('mouse_exited', self, 'toggle_price', [ $Price_01 ])
	$Gift_02.connect('mouse_entered', self, 'toggle_price', [ $Price_02 ])
	$Gift_02.connect('mouse_exited', self, 'toggle_price', [ $Price_02 ])
	$Gift_03.connect('mouse_entered', self, 'toggle_price', [ $Price_03 ])
	$Gift_03.connect('mouse_exited', self, 'toggle_price', [ $Price_03 ])

func _on_button_down(gift, cost):
	if can_play:
		if current_funds >= cost:
			match gift:
				'El Mostro':
					$Gift_01.hide()
					$Price_01.hide()
				'El Oso':
					$Gift_02.hide()
					$Price_02.hide()
				'La Micki':
					$Gift_03.hide()
					$Price_03.hide()

			EventsMgr.emit_signal('play_requested', 'VO/Seller', 'Sell')

			can_play = false

			get_node('../../..').has_gift = true
		else:
			if not buying_attempts == 3:
				buying_attempts += 1
				EventsMgr.emit_signal('play_requested', 'VO/Seller', gift)
				can_play = false
	
func _on_stream_finished(source, sound):
	if sound == 'Sell' or buying_attempts == 3:
		EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.ENDING)
		EventsMgr.emit_signal('stop_requested', 'BG', 'Store')
		EventsMgr.disconnect('stream_finished', self, '_on_stream_finished')
	else:
		can_play = true


func toggle_price(label: Label) -> void:
	label.set_visible(!label.is_visible())
