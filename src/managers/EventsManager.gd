extends Node
# Crea eventos de uso global para que cualquiera pueda emitir y conectarse a
# estas señales

# ░░░░ CONTROL DE ESCENAS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal scene_changed(id)

# ░░░░ AUDIO MANAGER ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal play_requested(source, sound)
signal stop_requested(source, sound)
signal pause_requested(source, sound)
