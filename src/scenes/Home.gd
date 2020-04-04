class_name Home
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
# TODO: Llenar esto de variables una gonorrea
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	$Cepillo.connect('button_down', self, '_on_button_down', ['Cepillo'])
	$Control.connect('button_down', self, '_on_button_down', ['Control'])
	$Tarea.connect('button_down', self, '_on_button_down', ['Tarea'])
	$Switch.connect('button_down', self, '_on_button_down', ['Switch'])


func _on_button_down(object: String) -> void:
	match object:
		'Cepillo':
			EventsMgr.emit_signal('play_requested', 'VO', 'Cepillo')
		'Control':
			EventsMgr.emit_signal('play_requested', 'VO', 'Tv')
		'Tarea':
			EventsMgr.emit_signal('play_requested', 'VO', 'Tarea')
		'Switch':
			EventsMgr.emit_signal('play_requested', 'VO', 'Switch')
			yield(get_tree().create_timer(1.8), 'timeout')
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.DOWNTOWN)
