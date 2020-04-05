extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(int) var worktime = 3

var _next_tick: float = 1.0
var _pedestrian_tscn: PackedScene = load('res://src/characters/pedestrian/Pedestrian.tscn')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Conectar escuchadores de eventos
	$Timer.connect('timeout', self, 'spawn_pedestrian')
	EventsMgr.connect('day_finished', self, 'go_home')
	# Iniciar la escena
	_trigger_tick()
	EventsMgr.emit_signal('day_started', worktime * 60)


func _trigger_tick() -> void:
	randomize()
	$Timer.wait_time = randi() % 5 + 1
	$Timer.start()


func spawn_pedestrian() -> void:
	var ped: Pedestrian = _pedestrian_tscn.instance()
	
	randomize()
	if randi() % 100 > 50:
		ped.position.x = 0
		ped.target_pos = 488
	else:
		ped.position.x = 488
		ped.target_pos = 0
	ped.modulate = Color(0.5 + randf(), 0.5 + randf(), 0.5 + randf())
	
	$Pedestrians.add_child(ped)

	_trigger_tick()


func go_home() -> void:
	EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.HOME)
