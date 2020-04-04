class_name Pedestrian
extends KinematicBody2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var target_pos: float = 0

var _speed: int = 6
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	if self.position.x > target_pos:
		$AnimatedSprite.flip_h = true
	
	$Tween.connect('tween_completed', self, '_remove_self')
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


func _remove_self(target: KinematicBody2D, path: NodePath) -> void:
	self.queue_free()
