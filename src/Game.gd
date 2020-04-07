class_name Game
extends Node2D
# Controla lo que pasa en el juego y se encarga de cargar escenas.
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(ConstantsMgr.Scene) var initial_scene = ConstantsMgr.Scene.MENU
export(int) var funds = 5000
export(int) var days_to_birthday = 3
export(int) var day = 8
export(int) var day_to_day = 15000

var has_gift = false

var _current_scene: Node

onready var scene_container: Node2D = $World/SceneContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Poner datos iniciales
	DataMgr.data_set(ConstantsMgr.DataIds.FUNDS, funds)
	DataMgr.data_set(ConstantsMgr.DataIds.AUDIENCE, 0)
	DataMgr.data_set(ConstantsMgr.DataIds.DAYS_LEFT, days_to_birthday)
	DataMgr.data_set(ConstantsMgr.DataIds.DAY, day)
	DataMgr.data_set(ConstantsMgr.DataIds.DAY_TO_DAY, day_to_day)
	
	var scn_name: String = ConstantsMgr.Scene.keys()[initial_scene]
	var scn_id: String = ConstantsMgr.Scenes[scn_name]
	
	_current_scene = load('res://src/scenes/%s.tscn' % scn_id).instance()
	scene_container.add_child(_current_scene)
	
	# Conectar escuchadores de señal
	EventsMgr.connect('scene_changed', self, 'change_scene')
	EventsMgr.connect('coin_inserted', self, '_increase_earnings')
	EventsMgr.connect('game_finished', self, '_reset_game')
	


func change_scene(id: String) -> void:
	if _current_scene.name == ConstantsMgr.Scenes.DOWNTOWN:
		DataMgr.data_sumi(ConstantsMgr.DataIds.DAYS_LEFT, -1)
		DataMgr.data_sumi(ConstantsMgr.DataIds.DAY, 1)
	
	scene_container.remove_child(_current_scene)
	_current_scene.queue_free()
	
	_current_scene = load('res://src/scenes/%s.tscn' % id).instance() as Node2D
	
	scene_container.add_child(_current_scene)


func _increase_earnings(amount: float = 0.0) -> void:
	funds += amount * 1000
	
	# Actualizar fondos en DataManager
	DataMgr.data_set(ConstantsMgr.DataIds.FUNDS, funds)
	
	print('Hay %d lucas en la marrana' % funds)

func _reset_game():
	print('volvio a empezar')
	funds = 3000
