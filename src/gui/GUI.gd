class_name GUI
extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var _keys_to_press: CenterContainer = $Control/KeysToPress
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Poner estado por defecto a las cosas
	_keys_to_press.hide()
	
	# Conectar escuchadores de señales
	EventsMgr.connect('keys_required', self, 'show_keys')


func show_keys() -> void:
	_keys_to_press.start()
