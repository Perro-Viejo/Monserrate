class_name GUI
extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var _keys_to_press: KeyToPress = $Control/KeysToPress
onready var _clock: CenterContainer = $Control/Clock
onready var arrow = load('res://assets/sprites/gui/cursor-arrow.png')
onready var move = load('res://assets/sprites/gui/cursor-pointing_hand.png')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Poner estado por defecto a las cosas
	_keys_to_press.hide()
	_clock.hide()
	
	# Conectar escuchadores de señales
	EventsMgr.connect('moves_required', self, 'show_keys')
	EventsMgr.connect('day_started', self, 'show_clock')
	EventsMgr.connect('day_finished', self, 'hide_all')
	
	# Enchular cursor
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(move, Input.CURSOR_POINTING_HAND)


func show_keys() -> void:
	_keys_to_press.start()


func show_clock(duration: int) -> void:
	_clock.start(duration)


func hide_all() -> void:
	_keys_to_press.close()
	_clock.hide()
