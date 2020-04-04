extends Node
# Crea eventos de uso global para que cualquiera pueda emitir y conectarse a
# estas señales

# ░░░░ ESCENAS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal scene_changed(id)

# ░░░░ GUI ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal coin_inserted()

# ░░░░ AUDIO MANAGER ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal play_requested(source, sound)
signal stop_requested(source, sound)
signal pause_requested(source, sound)
signal stream_finished(source, sound)
