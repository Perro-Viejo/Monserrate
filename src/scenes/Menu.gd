extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Start.connect('button_down', self, '_go_home')
	$Credits.connect('toggled', self, '_show_credits')
	
	EventsMgr.emit_signal('play_requested', 'MX', 'Menu')


func _go_home() -> void:
	EventsMgr.emit_signal('play_requested', 'UI', 'Click')
	EventsMgr.emit_signal('scene_changed', ConstantsMgr.Scenes.HOME)
	EventsMgr.emit_signal('stop_requested', 'MX', 'Menu')

func _show_credits(pressed):
	if pressed:
		$Creditos.show()
		EventsMgr.emit_signal('play_requested', 'UI', 'Click')
	else:
		$Creditos.hide()
		EventsMgr.emit_signal('play_requested', 'UI', 'Click')
