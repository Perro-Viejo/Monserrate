class_name Game
extends Node2D
# Controla lo que pasa en el juego y se encarga de cargar escenas.
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(ConstantsMgr.Scene) var initial_scene = ConstantsMgr.Scene.MENU

var _current_scene: Node

onready var scene_container: Node2D = $World/SceneContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	var scn_name: String = ConstantsMgr.Scene.keys()[initial_scene]
	_current_scene = load('res://src/scenes/%s.tscn' % scn_name).instance()
	scene_container.add_child(_current_scene)
	
	# Conectar escuchadores de señal
	EventsMgr.connect('scene_changed', self, 'change_scene')


func change_scene(id: String) -> void:
	scene_container.remove_child(_current_scene)
	
	_current_scene = load('res://src/scenes/%s.tscn' % id).instance() as Node2D
	
	scene_container.add_child(_current_scene)
