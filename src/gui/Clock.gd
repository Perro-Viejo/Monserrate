class_name Clock
extends CenterContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func start(worktime: int) -> void:
	show()
	
	if not $Tween.is_connected('tween_completed', self, '_finish_day'):
		$Tween.connect('tween_completed', self, '_finish_day')
	
	$Tween.interpolate_property(
		$Progress,
		'value',
		100,
		0,
		worktime,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()


func _finish_day(obj: TextureProgress, path: NodePath) -> void:
	EventsMgr.emit_signal('day_finished')
