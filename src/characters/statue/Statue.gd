extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(int) var cooldown = 5

enum States { SHOWING, WAITING, GOODBYE, SHAME }

var _current_state: int = States.WAITING setget set_current_state
var _pedestrian_waiting: bool = false

var radio_playing: bool = false

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Conectar escuchadores de señales
	EventsMgr.connect('coin_inserted', self, '_start_presentation')
	EventsMgr.connect('performance_finished', self, '_say_bye')
	EventsMgr.connect('pose_changed', self, '_play_pose')
	EventsMgr.connect('stream_finished', self, '_radio_finished')
	# Iniciar la escena
	_pose()


func set_current_state(state: int) -> void:
	_current_state = state
	
	match _current_state:
		States.GOODBYE:
			_pedestrian_waiting = false
			$Sprite.play('Bye')
		States.WAITING:
			$Sprite.play('Stand')
		States.SHAME:
			$Sprite.play('Shame')


func _start_presentation(amount: float = 0.0) -> void:
	if _current_state == States.WAITING:
		if not radio_playing:
			EventsMgr.emit_signal('play_requested','Objects', 'Radio')
			radio_playing = true
		self._current_state = States.SHOWING

		EventsMgr.emit_signal('moves_required')
	else:
		_pedestrian_waiting = true

func _radio_finished(source, sound):
	if sound == 'Radio':
		radio_playing = false

func _say_bye(quit: bool = false) -> void:
	if not quit:
		self._current_state = States.GOODBYE
	else:
		_pedestrian_waiting = false
		self._current_state = States.SHAME
		EventsMgr.emit_signal('stop_requested', 'Objects', 'Radio')
		radio_playing = false
		
	yield(get_tree().create_timer(cooldown), 'timeout')
	_pose()


func _pose() -> void:
	self._current_state = States.WAITING
	if _pedestrian_waiting:
		_pedestrian_waiting = false
		_start_presentation()


func _play_pose(direction: int) -> void:
	match direction:
		ConstantsMgr.Arrow.LEFT:
			$Sprite.play('Left')
		ConstantsMgr.Arrow.UP:
			$Sprite.play('Up')
		ConstantsMgr.Arrow.RIGHT:
			$Sprite.play('Right')
		ConstantsMgr.Arrow.DOWN:
			$Sprite.play('Down')
		_:
			$Sprite.play('Stand')
