class_name Game
extends Node2D
# Controla lo que pasa en el juego y se encarga de cargar escenas.
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(ConstantsMgr.Scene) var initial_scene = ConstantsMgr.Scene.MENU
export (int) var funds = 5000

var has_gift = false

var _current_scene: Node

onready var scene_container: Node2D = $World/SceneContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Poner datos iniciales
	DataMgr.set_data('funds', funds)
	
	var scn_name: String = ConstantsMgr.Scene.keys()[initial_scene]
	var scn_id: String = ConstantsMgr.Scenes[scn_name]
	
	_current_scene = load('res://src/scenes/%s.tscn' % scn_id).instance()
	scene_container.add_child(_current_scene)
	
	# Conectar escuchadores de señal
	EventsMgr.connect('scene_changed', self, 'change_scene')
	EventsMgr.connect('coin_inserted', self, '_increase_earnings')


func change_scene(id: String) -> void:
	scene_container.remove_child(_current_scene)
	
	_current_scene = load('res://src/scenes/%s.tscn' % id).instance() as Node2D
	
	scene_container.add_child(_current_scene)


func _increase_earnings(amount: float = 0.0) -> void:
	funds += amount * 1000
	
	# Actualizar fondos en DataManager
	DataMgr.set_data('funds', funds)
	
	print('Hay %d lucas en la marrana' % funds)
