extends Node2D

var can_play = true

func _ready():
	EventsMgr.connect('stream_finished', self, '_on_stream_finished')
	EventsMgr.emit_signal('play_requested', 'BG', 'Ending')
	
	if get_node('../../..').has_gift:
		EventsMgr.emit_signal('play_requested','VO/Main', 'FelizCumple')
		yield(get_tree().create_timer(2.4), 'timeout')
		EventsMgr.emit_signal('play_requested','VO/Girl', 'Gracias')
	else:
		EventsMgr.emit_signal('play_requested','VO/Main', 'Sad')
		yield(get_tree().create_timer(2.4), 'timeout')
		EventsMgr.emit_signal('play_requested','VO/Girl', 'TeQuiero')

func _on_stream_finished(source, sound):
	if source == 'VO/Girl':
		yield(get_tree().create_timer(3), 'timeout')
		EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.MENU)
		EventsMgr.emit_signal('stop_requested', 'BG', 'Ending')
		EventsMgr.emit_signal('game_finished')
