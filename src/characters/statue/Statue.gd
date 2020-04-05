extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(int) var cooldown = 5

enum States { SHOWING, WAITING, GOODBYE }

var _current_state: int = States.WAITING setget set_current_state
var _pedestrian_waiting: bool = false
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Conectar escuchadores de señales
	EventsMgr.connect('coin_inserted', self, '_start_presentation')
	EventsMgr.connect('presentation_finished', self, '_say_bye')
	# Iniciar la escena
	_pose()


func set_current_state(state: int) -> void:
	_current_state = state


func _start_presentation(amount: float = 0.0) -> void:
	if _current_state == States.WAITING:
		self._current_state = States.SHOWING

		EventsMgr.emit_signal('presentation_started')
	else:
		_pedestrian_waiting = true


func _say_bye() -> void:
	# TODO: Ejecutar animación de despedida
	print('Adiós amigos clientes')
	
	self._current_state = States.GOODBYE
	_pedestrian_waiting = false
	
	get_tree().create_timer(cooldown).connect('timeout', self, '_pose')


func _pose() -> void:
	print('Estoy listo para moverme')
	self._current_state = States.WAITING
	if _pedestrian_waiting:
		_pedestrian_waiting = false
		_start_presentation()
