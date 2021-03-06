extends Node
# Crea eventos de uso global para que cualquiera pueda emitir y conectarse a
# estas señales

# ░░░░ ESCENAS ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal scene_changed(id)
signal game_finished()

# ░░░░ STATUE ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal coin_inserted(amount)
signal performance_started()
signal pose_changed(pose)
signal performance_finished(quit)
signal tip_given(amount)

# ░░░░ GUI ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal moves_required()
signal day_started(duration)
signal day_finished()

# ░░░░ AUDIO MANAGER ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
signal play_requested(source, sound)
signal stop_requested(source, sound)
signal pause_requested(source, sound)
signal stream_finished(source, sound)
