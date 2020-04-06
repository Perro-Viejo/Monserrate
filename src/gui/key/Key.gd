class_name Key
extends TextureProgress
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
signal done(key)

enum States { WAITING, ACTIVE, INACTIVE }

# Que esté o no activa lo determina el papaito (KeysToPress.gd)
var idx: int = -1
var direction: int = -1

var can_play = true
var was_pressing: bool = false
var press_time: float = 3.0

var _target_action: String = ''
var _press_started: bool = false
var _current_state: int = States.WAITING setget set_current_state
var _current_direction: int = -ConstantsMgr.Arrow.RND
var _first_press: bool = false
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _init() -> void:
	self._current_state = States.WAITING


func _ready() -> void:
	# Definir dirección aleatoria si no hay una definida
	if direction < 0:
		randomize()
		direction = randi() % 4 # Un número aleatorio entre 0 y 3
	
	_current_direction = direction
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
	$Tween.connect('tween_step', self, 'tween_step')
	$Tween.connect('tween_completed', self, 'tween_completed')


func _unhandled_key_input(event: InputEventKey) -> void:
	if not _current_state == States.ACTIVE: return
	
	if event.is_action(_target_action):
		if not _press_started:
			_press_started = true
			
			start_tween(self.value, 0)
			
			# Enviar señal para cambiar de pose
			EventsMgr.emit_signal('pose_changed', _current_direction)
			
			# Si es el primer movimiento y se presiona la flecha por primera
			# vez, entonces es que inició la presentación ---------------------
			if idx == 0 and not _first_press:
				_first_press = true
				EventsMgr.emit_signal('performance_started')
			# -----------------------------------------------------------------
		else:
			if value <= 60 && can_play:
				EventsMgr.emit_signal('play_requested','VO/Main', 'Casi')
				can_play = false
			was_pressing = true


func set_current_state(state: int) -> void:
	_current_state = state

	match _current_state:
		States.WAITING:
			modulate = Color(1.0, 1.0, 1.0, 0.5)
		States.ACTIVE:
			modulate = Color(1.0, 1.0, 1.0, 1.0)
		States.INACTIVE:
			modulate = Color(1.0, 1.0, 1.0, 0.2)


func tween_step(obj: Object, key: NodePath, elapsed: float, val: float) -> void:
	if not _current_state == States.ACTIVE:
		$Tween.remove(self, 'value')
		return
	
	if was_pressing and not Input.is_action_pressed(_target_action):
		# Si ya estaba presionando y dejó de presionar
		was_pressing = false
		_press_started = false
		
		$Tween.stop(self, 'value')
		$Tween.remove(self, 'value')
		
		# Cambiar el tween para que ahora vaya en dirección contraria
		start_tween(val, 100.0)


func tween_completed(obj: TextureProgress, key: NodePath) -> void:
	if self.value == 0:
		self._current_state = States.INACTIVE
		can_play = true
		EventsMgr.emit_signal('play_requested','VO/Main', 'KeyDone')
		emit_signal('done', self)
	elif self.value == 100.0:
		# Volvió al inicio, ¿Qué hacer?
		print('( ~_~ )')


func set_active() -> void:
	self._current_state = States.ACTIVE


func start_tween(i: float, f: float) -> void:
	var t: float = (i * press_time) / 100.0
	
	if f > i and i > 0:
		t = press_time / (i * 0.3)
	
	$Tween.interpolate_property(self, 'value', i, f, t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
