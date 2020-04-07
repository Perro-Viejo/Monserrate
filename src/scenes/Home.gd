class_name Home
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
# TODO: Llenar esto de variables una gonorrea
export (int) var first_day = -30
export (int) var prev_days = 0
export (int) var last_day = 30
export (int) var current_day = 8

var playing_action = false
var x: PackedScene = load('res://src/scenes/X.tscn')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	EventsMgr.connect('stream_finished', self, '_on_stream_finished')
	EventsMgr.connect('game_finished', self, '_reset_home')
	
	$Cepillo.connect('button_down', self, '_on_button_down', ['Cepillo'])
	$Control.connect('button_down', self, '_on_button_down', ['Control'])
	$Tarea.connect('button_down', self, '_on_button_down', ['Tarea'])
	$Switch.connect('button_down', self, '_on_button_down', ['Switch'])
	
	# Ponerle números a los días del calendario
	var day_num: int = first_day
	for day in $Calendario/Testos.get_children():
		if day.name.find('Label') < 0:
			(day as Label).text = String(abs(day_num))
			
			if day_num < current_day:
				var _x: Control = x.instance() as Control
				day.add_child(_x)
				day.self_modulate = Color(1, 1, 1, 0.5)

			prev_days -= 1
			if prev_days > 0:
				day_num = first_day - 1
			else:
				day_num = (abs(day_num) + 1) % (last_day + 1)


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
	
	if sound == 'Switch':
		if DataMgr.data_get(ConstantsMgr.DataIds.DAYS_LEFT) > 0:
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.DOWNTOWN)
		else:
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.STORE)
