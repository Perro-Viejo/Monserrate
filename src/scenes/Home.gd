class_name Home
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
# TODO: Llenar esto de variables una gonorrea
export (int) var days_left = 3

var playing_action = false
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	EventsMgr.connect('stream_finished', self, '_on_stream_finished')
	EventsMgr.connect('game_finished', self, '_reset_home')
	
	$Cepillo.connect('button_down', self, '_on_button_down', ['Cepillo'])
	$Control.connect('button_down', self, '_on_button_down', ['Control'])
	$Tarea.connect('button_down', self, '_on_button_down', ['Tarea'])
	$Switch.connect('button_down', self, '_on_button_down', ['Switch'])


func _on_button_down(object: String) -> void:
	if not playing_action:
		match object:
			'Cepillo':
				EventsMgr.emit_signal('play_requested', 'VO/Main', 'Cepillo')
			'Control':
				EventsMgr.emit_signal('play_requested', 'VO/Main', 'Tv')
			'Tarea':
				EventsMgr.emit_signal('play_requested', 'VO/Girl', 'Tarea')
			'Switch':
				EventsMgr.emit_signal('play_requested', 'VO/Main', 'Switch')
				
		playing_action = true

func _on_stream_finished(source, sound):
	playing_action = false
	print(days_left)
	if sound == 'Switch':
		if not days_left == 0:
			days_left -= 1
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.DOWNTOWN)
		else:
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.STORE)
