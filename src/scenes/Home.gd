class_name Home
extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
# TODO: Llenar esto de variables una gonorrea
export (int) var first_day = -30
export (int) var prev_days = 0
export (int) var last_day = 30

var playing_action = false
var x: PackedScene = load('res://src/scenes/X.tscn')
var o: PackedScene = load('res://src/scenes/O.tscn')

var _current_day: int
var _days_left: int

onready var _expenses: Label = $VBoxContainer/DayExpenses/Value
onready var _profit: Label = $VBoxContainer/DayProfit/Value
onready var _savings: Label = $VBoxContainer/DaySavings/Value
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	_current_day = DataMgr.data_get(ConstantsMgr.DataIds.DAY)
	_days_left = DataMgr.data_get(ConstantsMgr.DataIds.DAYS_LEFT)
	
	EventsMgr.connect('stream_finished', self, '_on_stream_finished')
	EventsMgr.connect('game_finished', self, '_reset_home')
	
	EventsMgr.emit_signal('play_requested', 'BG', 'Home')
	
	$Cepillo.connect('button_down', self, '_on_button_down', ['Cepillo'])
	$Control.connect('button_down', self, '_on_button_down', ['Control'])
	$Tarea.connect('button_down', self, '_on_button_down', ['Tarea'])
	$Switch.connect('button_down', self, '_on_button_down', ['Switch'])
	
	# Ponerle números a los días del calendario
	var day_num: int = first_day
	for day in $Calendario/Testos.get_children():
		if day.name.find('Label') < 0:
			(day as Label).text = String(abs(day_num))
			
			if day_num < _current_day:
				var _x: Control = x.instance() as Control
				day.add_child(_x)

				day.self_modulate = Color(1, 1, 1, 0.5)
			
			if day_num == _current_day + _days_left:
				var _o: Control = o.instance() as Control
				_o.rect_position -= Vector2.ONE * 5.0
				day.add_child(_o)

			prev_days -= 1
			if prev_days > 0:
				day_num = first_day - 1
			else:
				day_num = (abs(day_num) + 1) % (last_day + 1)
	
	# La luca
	var __funds: int = DataMgr.data_get(ConstantsMgr.DataIds.FUNDS)
	var __day_to_day: int = DataMgr.data_get(ConstantsMgr.DataIds.DAY_TO_DAY)
	var __savings: int = __funds - __day_to_day

	_expenses.text = '$%d' % __day_to_day
	_profit.text = '$%d' % __funds
	_savings.text = '$%d' % __savings
	
	DataMgr.data_set(ConstantsMgr.DataIds.FUNDS, _savings)


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
	if sound == 'A'||'B'||'C':
		playing_action = false
	
	match sound:
		'Cepillo':
			EventsMgr.emit_signal('play_requested', 'Actions', 'A')
		'Tv':
			EventsMgr.emit_signal('play_requested', 'Actions', 'B')
		'Tarea':
			EventsMgr.emit_signal('play_requested', 'Actions', 'C')
		'Switch':
			EventsMgr.emit_signal('play_requested', 'Actions', 'D')			
	
	if sound == 'D':
		EventsMgr.emit_signal('stop_requested', 'BG', 'Home')
		if _days_left > 0:
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.DOWNTOWN)
		else:
			EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.STORE)
