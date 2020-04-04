class_name Home
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
# TODO: Llenar esto de variables una gonorrea
var playing_action = false
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	EventsMgr.connect('stream_finished', self, '_on_stream_finished')
	
	$Cepillo.connect('button_down', self, '_on_button_down', ['Cepillo'])
	$Control.connect('button_down', self, '_on_button_down', ['Control'])
	$Tarea.connect('button_down', self, '_on_button_down', ['Tarea'])
	$Switch.connect('button_down', self, '_on_button_down', ['Switch'])


func _on_button_down(object: String) -> void:
	if not playing_action:
		match object:
			'Cepillo':
				EventsMgr.emit_signal('play_requested', 'VO', 'Cepillo')
			'Control':
				EventsMgr.emit_signal('play_requested', 'VO', 'Tv')
			'Tarea':
				EventsMgr.emit_signal('play_requested', 'VO', 'Tarea')
			'Switch':
				EventsMgr.emit_signal('play_requested', 'VO', 'Switch')
				
		playing_action = true

func _on_stream_finished(source, sound):
	playing_action = false
	if sound == 'Switch':
		EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.DOWNTOWN)
