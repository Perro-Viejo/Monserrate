class_name Pedestrian
extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var target_pos: float = 0

var _speed: int = 6
var _stingy_prob: float = 0.0
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	$Emoticon.hide()
	
	if self.position.x > target_pos:
		$AnimatedSprite.flip_h = true
		$Emoticon.position.x *= -1.0
	
	randomize()
	_stingy_prob = max(randf() - 0.2, 0.0)
	
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
		# TODO: Elegir al azar la cantidad a meter
		EventsMgr.emit_signal('coin_inserted')
		$Tween.stop(self, 'position:x')
		$AnimatedSprite.play('Look')
	else:
		$Emoticon.play('Sad' if rnd > 50 else 'Angry')
		print('Qué vida de mierda' if rnd > 50 else 'Prole hijueputa')


func _calm_down(area: Area2D) -> void:
	$Emoticon.hide()
