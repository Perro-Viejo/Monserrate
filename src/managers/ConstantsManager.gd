extends Node

# ░░░░ ESCENAS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
enum Scene { MENU, HOME, DOWNTOWN, STORE }
const Scenes: Dictionary = {
	MENU = 'Menu',
	HOME = 'Home',
	DOWNTOWN = 'Downtown',
	STORE = 'Store'
}

# ░░░░ DIRECCIÓN FLECHAS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
enum Arrow { RND = -1, LEFT, UP, RIGHT, DOWN }

# ░░░░ PASOS DE MOVIMIENTO ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
enum Step { RND = -1, ROBOT, SOLDIER, PEASANT }
const Steps: Dictionary = {
	ROBOT = [ Arrow.LEFT, Arrow.DOWN, Arrow.UP, Arrow.DOWN ],
	SOLDIER = [ Arrow.RIGHT, Arrow.UP, Arrow.UP, Arrow.RIGHT ],
	PEASANT = [ Arrow.DOWN, Arrow.DOWN, Arrow.LEFT, Arrow.RND ]
}
