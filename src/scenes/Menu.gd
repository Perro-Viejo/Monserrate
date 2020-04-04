extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect('button_down', self, '_go_home')


func _go_home() -> void:
	EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.HOME)
