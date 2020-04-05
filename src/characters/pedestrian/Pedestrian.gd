class_name Pedestrian
extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
enum States { WALKING, WATCHING }

var target_pos: float = 0

var _speed: int = 6
var _stingy_prob: float = 0.0
var _max: float = 0.0
# La cantidad de dinero que ponen cuando empieza a moverse la estatua
var _first_tip: float = 0.0
var _angry: bool = false
var current_state: int = States.WALKING
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	$Emoticon.hide()
	
	if self.position.x > target_pos:
		$AnimatedSprite.flip_h = true
		$Emoticon.position.x *= -1.0
	
	randomize()
	# Hay una probabilidad máxima del 80% de que vean la estatua
	_stingy_prob = max(randf() - 0.2, 0.0)
	# TODO: Hacer que la cantidad máxima a poner tenga en cuenta el nivel de
	# tacañez del peatón
	_max = 2.0

	$Tween.interpolate_property(
		self,
		'position:x',
		self.position.x,
		target_pos,
		_speed,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	$Tween.start()
	
	# Conectar estuchadores de señales
	$Tween.connect('tween_completed', self, '_remove_self')
	self.connect('area_entered', self, '_put_coin')
	self.connect('area_exited', self, '_calm_down')


func _remove_self(target: KinematicBody2D, path: NodePath) -> void:
	self.queue_free()


func _put_coin(area: Area2D) -> void:
	if area.name != 'Statue': return
	
	randomize()
	var rnd: int = randi() % 100
	
	$Emoticon.show()
	
	if randf() < _stingy_prob:
		current_state = States.WATCHING

		if rnd > 50:
			$Emoticon.play('Heart')
			EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Heart')
		else:
			$Emoticon.play('Happy')
			EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Happy')
		
		# Hacer que los peatones se muevan un tilín si ya otro está viendo para
		# que no se superpongan ───────────────────────────────────────────────┐
		var shift: int = 8
		
		if $AnimatedSprite.flip_h:
			shift *= -1
		
		for area in get_overlapping_areas():
			if area.name != 'Statue' \
				and (area as Pedestrian).current_state == States.WATCHING:
				# Que sólo se desplace si detecta que el área que está debajo
				# es un peatón VIENDO a la estatua.
				position.x += shift
		# └────────────────────────────────────────────────────────────────────┘
		
		# TODO: Poner retroalimentación de audio ♪ y visual Θ
		
		# Decidir cuánto poner y disparar el evento que lo notifica
		_first_tip = rand_range(0.2, _max / 2.0)
		EventsMgr.emit_signal('coin_inserted', _first_tip)
		
		# Detener el caminado y ponerse a ver
		$Tween.stop(self, 'position:x')
		$AnimatedSprite.play('Look')
		
		if not DataMgr.get('statue_moving'):
			# Iniciar temporizador de irse por impaciencia si la estatua no se
			# está moviendo ya
			_angry = false
			$Patience.connect('timeout', self, '_set_angry')
			$Patience.start()
		
		# Escuchar eventos relacionados a la presentación
		EventsMgr.connect('presentation_finished', self, '_leave', [ true ])
		EventsMgr.connect('presentation_started', self, '_stop_patience')
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
	_angry = true
	_leave()


func _leave(happy: bool = false) -> void:
	if happy: _angry = false

	if not _angry:
		randomize()
		if randf() < _stingy_prob:
			EventsMgr.emit_signal('tip_given', rand_range(_first_tip, _max))
			$Emoticon.play('Money')
			#un sonido de monedo aqui
	else:
		$Emoticon.play('Angry')
		EventsMgr.emit_signal('play_requested', 'VO/Pedestrian', 'Angry')

	$Emoticon.show()
	$Tween.resume(self, 'position:x')

	_disconnect()


func _stop_patience() -> void:
	_angry = false

	_disconnect()
	$Patience.stop()


func _disconnect() -> void:
	# Desconectar escuchadores de señales de la presentación
	EventsMgr.disconnect('presentation_finished', self, '_leave')
	EventsMgr.disconnect('presentation_started', self, '_stop_patience')
	
	if $Patience.is_connected('timeout', self, '_leave'):
		$Patience.disconnect('timeout', self, '_leave')
