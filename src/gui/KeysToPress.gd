class_name KeyToPress
extends CenterContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(ConstantsMgr.Step) var fix_step = ConstantsMgr.Step.RND

var active_idx: int setget set_active_idx

var _active_key: Key
var _no_press_count: float = 0.0
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func start() -> void:
	if is_visible(): return
	
	# Antes que cualquier cosa, verificar si hay teclas "acumuladas" y mandarlas
	# pa' la cholla
	if $KeysContainer.get_child_count() > 0:
		_clean()
	
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

	self.active_idx = 0
	
	# Conectar escuchador de temporizador
	if not $WaitToQuit.is_connected('timeout', self, '_quit_performance'):
		$WaitToQuit.connect('timeout', self, '_quit_performance')

	# Mostarse pa' que se vean las flechas
	show()


func _quit_performance() -> void:
	if _active_key == null: return
	
	if _active_key and (_active_key as Key).idx == active_idx:
		# Si se ha quedado en la misma pose por el tiempo de espera para
		# abandonar... entonces abandonar
		close()
		EventsMgr.emit_signal('performance_finished', true)


func to_next_key(done_key: Key) -> void:
	# Dejar de revisar si se preiona o no algo
	$WaitToQuit.stop()

	if done_key.idx + 1 == $KeysContainer.get_child_count():
		
		# Eliminar las flechas de atrás para adelante para que no se muera Godot
		close()
		EventsMgr.emit_signal('performance_finished', false)
		return

	self.active_idx = done_key.idx + 1


func close() -> void:
	_active_key = null
	active_idx = -1

	_clean()
	hide()


# Se llama cuando desde fuera hace '_active_key = algo' o desde dentro se hace
# 'self._active_key = algo'
func set_active_idx(idx: int) -> void:
	active_idx = idx

	if active_idx < 0:
		_active_key = null
		return
	
	
	_active_key = $KeysContainer.get_child(active_idx) as Key
	_active_key.set_active()
	
	# Iniciar el temporizador para saber si se abandona la presentación
	$WaitToQuit.start()


func _clean() -> void:
	for idx in range($KeysContainer.get_child_count() - 1, -1, -1):
		$KeysContainer.get_child(idx).queue_free()
