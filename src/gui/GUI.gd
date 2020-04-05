class_name GUI
extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var _keys_to_press: KeyToPress = $Control/KeysToPress
onready var _clock: CenterContainer = $Control/Clock
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Poner estado por defecto a las cosas
	_keys_to_press.hide()
	_clock.hide()
	
	# Conectar escuchadores de señales
	EventsMgr.connect('presentation_started', self, 'show_keys')
	EventsMgr.connect('day_started', self, 'show_clock')
	EventsMgr.connect('day_finished', self, 'hide_all')


func show_keys() -> void:
	_keys_to_press.start()


func show_clock(duration: int) -> void:
	_clock.start(duration)


func hide_all() -> void:
	_keys_to_press.close()
	_clock.hide()
