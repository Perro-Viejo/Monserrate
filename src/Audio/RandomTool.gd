extends Node2D


var index_sound = -1
var select_sound
var canplay

export (float) var Volume = -1
export (float) var Pitch = 0

export (bool) var RandomVolume
export (float) var minVolume
export (float) var maxVolume

export (bool) var RandomPitch
export (float) var minPitch
export (float) var maxPitch

var avVolume = 0
var ranVol = 0
var avPitch
var dflt_values: Dictionary

func _ready():
	Pitch = Pitch/24
	
	# Crear el diccionario de valores por defecto para los efectos de sonido
	# hijos
	for sfx in get_children():
		dflt_values[sfx.name] = {
			'pitch': sfx.get_pitch_scale(),
			'volume': sfx.get_volume_db()
		}


func play():
	randomize()
	
	index_sound = randi()%get_child_count()
	select_sound = get_child(index_sound)
	avVolume = (select_sound.get_volume_db() + Volume)
#
	if RandomVolume == true:
		randomizeVol(avVolume, minVolume, maxVolume)
		select_sound.set_volume_db(avVolume + ranVol)
	else:
		select_sound.set_volume_db(avVolume)
#
#
#	if RandomPitch == true:
#		select_sound.randomizePitch(avPitch, minPitch, maxPitch)
#	#	select_sound.set_pitch_scale((Pitch) + ranPitch)
#	else:
	select_sound.play()
	select_sound.set_pitch_scale(dflt_values[select_sound.name].pitch + Pitch)
	

func stop():
	select_sound.stop()

func randomizeVol(_Volume, _minVolume, _maxVolume):
	ranVol = (rand_range(_minVolume, _maxVolume+1))

#func randomizePitch(_Pitch, minPitch, maxPitch):
#		var ranPitch = (rand_range( minPitch + 1, (maxPitch+1)))
#		if (_Pitch + ranPitch > 0):
#			select_sound.set_pitch_scale((_Pitch + ranPitch))
