class_name Key
extends TextureProgress
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
signal done(key)

enum States { WAITING, ACTIVE, INACTIVE }

export(float) var press_time = 3

# Que esté o no activa lo determina el papaito (KeysToPress.gd)
var idx: int = -1
var direction: int = -1

var can_play = true

var _target_action: String = ''
var _first_press_done: bool = false
var _keeps_pressing: bool = false
var _current_state: int = States.WAITING setget set_current_state
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _init() -> void:
	self._current_state = States.WAITING


func _ready() -> void:
	# Definir dirección aleatoria si no hay una definida
	if direction < 0:
		randomize()
		direction = randi() % 4 # Un número aleatorio entre 0 y 3
	
	match direction:
		ConstantsMgr.Arrow.LEFT:
			$Arrow.rect_rotation = 0
			_target_action = 'ui_left'
		ConstantsMgr.Arrow.UP:
			$Arrow.rect_rotation = 90
			_target_action = 'ui_up'
		ConstantsMgr.Arrow.RIGHT:
			$Arrow.rect_rotation = 180
			_target_action = 'ui_right'
		ConstantsMgr.Arrow.DOWN:
			$Arrow.rect_rotation = 270
			_target_action = 'ui_down'
	
	# Conectar escuchadores de señales
	$Tween.connect('tween_completed', self, 'key_press_done')


func _process(delta: float) -> void:
	if not _current_state == States.ACTIVE: return
	if _keeps_pressing and not Input.is_action_pressed(_target_action):
		# Si ya estaba presionando y dejó de presionar
		_keeps_pressing = false
		$Tween.stop(self, 'value')


func _unhandled_key_input(event: InputEventKey) -> void:
	if not _current_state == States.ACTIVE: return
	if event.is_action(_target_action):
		if not _first_press_done:
			_first_press_done = true
			
			$Tween.interpolate_property(
				self,
				'value',
				self.value,
				0,
				press_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			$Tween.start()
			
		else:
			if value <= 15 && can_play:
				EventsMgr.emit_signal('play_requested','VO', 'Casi')
				can_play = false
			_keeps_pressing = true
			$Tween.resume(self, 'value')


func set_current_state(state: int) -> void:
	_current_state = state

	match _current_state:
		States.WAITING:
			modulate = Color(1.0, 1.0, 1.0, 0.5)
		States.ACTIVE:
			modulate = Color(1.0, 1.0, 1.0, 1.0)
		States.INACTIVE:
			modulate = Color(1.0, 1.0, 1.0, 0.2)


func key_press_done(object: Object, key: NodePath) -> void:
	self._current_state = States.INACTIVE
	can_play = true
	EventsMgr.emit_signal('play_requested','VO', 'KeyDone')
	emit_signal('done', self)


func set_active() -> void:
	self._current_state = States.ACTIVE
