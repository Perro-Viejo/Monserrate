class_name KeyToPress
extends CenterContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(ConstantsMgr.Step) var fix_step = ConstantsMgr.Step.RND

var _performance_started: bool = false
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func start() -> void:
	if is_visible(): return
	
	_performance_started = false
	
	show()
	
	# Seleccionar el patrón de movimientos
	var step: int = fix_step
	var keys: Array = ConstantsMgr.Steps.keys()
	
	if fix_step == ConstantsMgr.Step.RND:
		randomize()
		keys.shuffle()
		step = 0
	
	var rnd_key: String = keys[step]
	var pattern: Array = ConstantsMgr.Steps[rnd_key]
	var idx: int = 0
	
	for key_dir in pattern:
		var key: Key = load('res://src/gui/key/Key.tscn').instance()
		key.idx = idx
		key.direction = key_dir
		
		key.connect('done', self, 'to_next_key')
		
		$KeysContainer.add_child(key)
		
		idx += 1
	($KeysContainer.get_child(0) as Key).set_active()


func to_next_key(done_key: Key) -> void:
	if done_key.idx + 1 == $KeysContainer.get_child_count():
		# Eliminar las flechas de atrás para adelante para que no se muera Godot
		close()

		EventsMgr.emit_signal('performance_finished')
		
		return

	if not _performance_started:
		_performance_started = true
		EventsMgr.emit_signal('performance_started')

	($KeysContainer.get_child(done_key.idx + 1) as Key).set_active()


func close() -> void:
	for idx in range($KeysContainer.get_child_count() - 1, -1, -1):
		$KeysContainer.get_child(idx).queue_free()

	hide()
