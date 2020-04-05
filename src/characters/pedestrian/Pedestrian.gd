class_name Pedestrian
extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var target_pos: float = 0

var _speed: int = 6
var _stingy_prob: float = 0.0
var _max: float = 0.0
# La cantidad de dinero que ponen cuando empieza a moverse la estatua
var _first_tip: float = 0.0
var _angry: bool = false
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
	randomize()
	var rnd: int = randi() % 100
	
	$Emoticon.show()
	
	if randf() < _stingy_prob:
		print('¡Todo lo rico!' if rnd > 50 else '¡Esto se ve interesantosky!')
		$Emoticon.play('Heart' if rnd > 50 else 'Happy')
		
		# TODO: Poner retroalimentación audio y visual
		
		_first_tip = rand_range(0.2, _max / 2.0)
		
		# Disparar evento de metida de dinero
		EventsMgr.emit_signal('coin_inserted', _first_tip)
		
		# Detener el caminado y ponerse a pillar
		$Tween.stop(self, 'position:x')
		$AnimatedSprite.play('Look')
		
		# Escuchar eventos relacionados a la presentación
		EventsMgr.connect('presentation_finished', self, '_leave', [ true ])
		EventsMgr.connect('presentation_started', self, '_stop_patience')
		
		# Iniciar temporizador de irse por impaciencia
		_angry = false
		$Patience.connect('timeout', self, '_set_angry')
		$Patience.start()
	else:
		$Emoticon.play('Sad' if rnd > 50 else 'Angry')
		print('Qué vida de mierda' if rnd > 50 else 'Prole hijueputa')


func _calm_down(area: Area2D) -> void:
	$Emoticon.hide()


func _leave(happy: bool) -> void:
	if happy: _angry = false

	if not _angry:
		randomize()
		if randf() < _stingy_prob:
			EventsMgr.emit_signal('tip_given', rand_range(_first_tip, _max))
			$Emoticon.play('Money')
	else:
		print('Por eso es que se quedan pobres los malparidos')
		$Emoticon.play('Angry')

	$Tween.resume(self, 'position:x')
	
	_disconnect()


func _disconnect() -> void:
	# Desconectar escuchadores de señales de la presentación
	EventsMgr.disconnect('presentation_finished', self, '_leave')
	EventsMgr.disconnect('presentation_started', self, '_stop_patience')
	
	if $Patience.is_connected('timeout', self, '_leave'):
		$Patience.disconnect('timeout', self, '_leave')


func _set_angry() -> void:
	_angry = true


func _stop_patience() -> void:
	_angry = false

	_disconnect()
	$Patience.stop()
