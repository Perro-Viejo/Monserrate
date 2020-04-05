extends Node
# Clase que copia la idea y parte de la funcionalidad del DataManager de Phaser
# para tener un lugar centralizado en el que cualquier nodo pueda acceder y
# guardar datos de uso transversal en el juego
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var _list: Dictionary = {}
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func get_data(key: String):
	return _list[key] if _list.has(key) else null


func set_data(key: String, data) -> Node:
	_list[key] = data
	return self
