class_name Pedestrian
extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
enum States { WALKING, WATCHING }

const Colors: Array = [
	'c38890',
	'8b5580',
	'be955c',
	'93a167',
	'416aa3',
	'c28d75'
]
const Moneys: Array = [ 0.1, 0.2, 0.5, 1.0, 2.0 ]

var target_pos: float = 0

var _speed: int = 6
var _shift: int = 12
var _stingy_prob: float = 0.0
var _max: float = 0.0
# La cantidad de dinero que ponen cuando empieza a moverse la estatua
var _first_tip: float = 0.0
var _angry: bool = false
var _current_state: int setget set_current_state
var _tween_time: float = 0.0
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	$Emoticon.hide()
	
	if self.position.x > target_pos:
		_shift *= -1
		$AnimatedSprite.flip_h = true
		$Emoticon.position.x *= -1.0
		$CollisionShape2D.position.x *= -1.0
	
	randomize()
	# Hay una probabilidad máxima del 80% de que vean la estatua
	_stingy_prob = max(randf() - 0.2, 0.0)
	# TODO: Hacer que la cantidad máxima a poner tenga en cuenta el nivel de
	# tacañez del peatón
	_max = Moneys.max() as float
	
	# Cambiar color de contorno al azar
	$AnimatedSprite.modulate = Color(Colors[randi() % Colors.size()])

	# Ponerla a caminar
	_walk()
	
	# Conectar estuchadores de señales
	$Tween.connect('tween_completed', self, '_remove_self')
	self.connect('area_entered', self, '_put_coin')
	self.connect('area_exited', self, '_calm_down')
	


func set_current_state(new_state: int) -> void:
	_current_state = new_state
	
	match _current_state:
		States.WALKING:
			$AnimatedSprite.play('Walk')
		States.WATCHING:
			$AnimatedSprite.play('Look')


func _walk() -> void:
	$Tween.interpolate_property(
		self,
		'position:x',
		self.position.x,
		target_pos,
		_speed - _tween_time,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	$Tween.start()
	self._current_state = States.WALKING


func _remove_self(target: KinematicBody2D, path: NodePath) -> void:
	self.queue_free()


func _put_coin(area: Area2D) -> void:
	if area.name != 'Statue': return

	randomize()
	var rnd: int = randi() % 100
	
	$Emoticon.show()
	
	if DataMgr.data_get(ConstantsMgr.DataIds.AUDIENCE) < 6 \
		and randf() < _stingy_prob:
		self._current_state = States.WATCHING

		if rnd > 50:
			$Emoticon.play('Heart')
			EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Heart')
		else:
			$Emoticon.play('Happy')
			EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Happy')
		
		# Hacer que los peatones se muevan un tilín si ya otro está viendo para
		# que no se superpongan ───────────────────────────────────────────────┐

		for area in get_overlapping_areas():
			if area.name != 'Statue' \
				and (area as Pedestrian)._current_state == States.WATCHING:
				# Que sólo se desplace si detecta que el área que está debajo
				# es un peatón VIENDO a la estatua.
				position.x += _shift
		# └────────────────────────────────────────────────────────────────────┘
		
		# TODO: Poner retroalimentación de audio ♪ y visual Θ
		
		# Decidir cuánto poner y disparar el evento que lo notifica
		_first_tip = take_from_pocket()
		EventsMgr.emit_signal('coin_inserted', _first_tip)
		
		# Detener el caminado y ponerse a ver
		_tween_time = $Tween.tell()
		$Tween.stop(self, 'position:x')
		$AnimatedSprite.play('Look')
		
		if not DataMgr.data_get('statue_moving'):
			# Iniciar temporizador de irse por impaciencia si la estatua no se
			# está moviendo ya
			_angry = false
			$Patience.connect('timeout', self, '_set_angry')
			$Patience.start()
		
		# Escuchar eventos relacionados a la presentación
		EventsMgr.connect('performance_finished', self, '_leave')
		EventsMgr.connect('performance_started', self, '_stop_patience')
		
		# Aumentar el contador de expectadores
		DataMgr.data_sumi(ConstantsMgr.DataIds.AUDIENCE, 1)
	else:
		if rnd > 50:
			$Emoticon.play('Sad')
			EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Sad')
		else:
			$Emoticon.play('Angry')
			EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Angry')


func _calm_down(area: Area2D) -> void:
	if _angry: return
	$Emoticon.hide()


func _set_angry() -> void:
	if not DataMgr.data_get('statue_moving'):
		_angry = true
		_leave()


func _leave(quit: bool = false) -> void:
	self._current_state = States.WALKING
	
	if not _angry and not quit:
		randomize()
		if randf() < _stingy_prob:
			EventsMgr.emit_signal('tip_given', take_from_pocket())
			$Emoticon.play('Money')
			#un sonido de monedo aqui
	else:
		$Emoticon.play('Angry')
		EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Angry')

	$Emoticon.show()
	_walk()

	_disconnect()
	
	# Reducir el contador de expectadores
	DataMgr.data_sumi(ConstantsMgr.DataIds.AUDIENCE, -1)


func _stop_patience() -> void:
	_angry = false

	$Patience.stop()


func _disconnect() -> void:
	# Desconectar escuchadores de señales de la presentación
	if EventsMgr.is_connected('performance_finished', self, '_leave'):
		EventsMgr.disconnect('performance_finished', self, '_leave')
	if EventsMgr.is_connected('performance_started', self, '_stop_patience'):
		EventsMgr.disconnect('performance_started', self, '_stop_patience')
	# Desconectarse del Timer de la impaciencia
	if $Patience.is_connected('timeout', self, '_leave'):
		$Patience.disconnect('timeout', self, '_leave')


func take_from_pocket() -> float:
	return Moneys[randi() % Moneys.size()] as float
