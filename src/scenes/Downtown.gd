extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var _next_tick: float = 1.0
var _pedestrian_tscn: PackedScene = load('res://src/characters/pedestrian/Pedestrian.tscn')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	$Timer.connect('timeout', self, 'spawn_pedestrian')
	
	_trigger_tick()


func _trigger_tick() -> void:
	randomize()
	$Timer.wait_time = randi() % 5 + 1
	$Timer.start()


func _coin_inserted() -> void:
	# Emitir señal para que GUI muestre las teclas a presionar.
	EventsMgr.emit_signal('keys_required')


func spawn_pedestrian() -> void:
	var ped: Pedestrian = _pedestrian_tscn.instance()
	
	randomize()
	if randi() % 100 > 50:
		ped.position.x = 0
		ped.target_pos = 488
	else:
		ped.position.x = 488
		ped.target_pos = 0
	
	$Pedestrians.add_child(ped)

	_trigger_tick()
