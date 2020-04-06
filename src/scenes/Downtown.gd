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
	EventsMgr.connect('performance_started', self, '_set_moving')
	EventsMgr.connect('performance_finished', self, '_set_not_moving')
	
	# Iniciar la escena
	_set_not_moving()
	_trigger_tick()
	EventsMgr.emit_signal('day_started', worktime * 60)


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


func go_home() -> void:
	EventsMgr.emit_signal('play_requested', 'VO/Main', 'Jornada_Fin')
	yield(get_tree().create_timer(2), 'timeout')
	EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.HOME)


func _set_moving() -> void:
	DataMgr.data_set('statue_moving', true)


func _set_not_moving(quit: bool = false) -> void:
	DataMgr.data_set('statue_moving', false)


func _trigger_tick() -> void:
	randomize()
	$Timer.wait_time = randi() % 5 + 1
	$Timer.start()
