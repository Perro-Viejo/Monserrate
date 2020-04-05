extends Node
# Crea eventos de uso global para que cualquiera pueda emitir y conectarse a
# estas señales

# ░░░░ ESCENAS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal scene_changed(id)

# ░░░░ STATUE ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal coin_inserted(amount)
signal presentation_finished()
signal tip_given(amount)
signal presentation_started()

# ░░░░ GUI ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal day_started(duration)
signal day_finished()

# ░░░░ AUDIO MANAGER ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal play_requested(source, sound)
signal stop_requested(source, sound)
signal pause_requested(source, sound)
signal stream_finished(source, sound)
