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
	EventsMgr.connect('pose_changed', self, '_play_pose')
	# Iniciar la escena
	_pose()


func set_current_state(state: int) -> void:
	_current_state = state
	
	match _current_state:
		States.GOODBYE:
			_pedestrian_waiting = false
			$Sprite.frame = 5
		States.WAITING:
			$Sprite.frame = 0


func _start_presentation(amount: float = 0.0) -> void:
	if _current_state == States.WAITING:
		self._current_state = States.SHOWING

		EventsMgr.emit_signal('presentation_started')
	else:
		_pedestrian_waiting = true


func _say_bye() -> void:
	# TODO: Ejecutar animación de despedida
	
	self._current_state = States.GOODBYE
	
	get_tree().create_timer(cooldown).connect('timeout', self, '_pose')


func _pose() -> void:
	self._current_state = States.WAITING
	if _pedestrian_waiting:
		_pedestrian_waiting = false
		_start_presentation()


func _play_pose(direction: int) -> void:
	match direction:
		ConstantsMgr.Arrow.LEFT:
			$Sprite.frame = 2
		ConstantsMgr.Arrow.UP:
			$Sprite.frame = 4
		ConstantsMgr.Arrow.RIGHT:
			$Sprite.frame = 1
		ConstantsMgr.Arrow.DOWN:
			$Sprite.frame = 3
		_:
			$Sprite.frame = 0
