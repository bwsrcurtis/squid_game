extends Node2D

func _on_player_player_died():
	get_tree().reload_current_scene()

func _on_animation_player_animation_finished(_fade_in):
	get_tree().paused = false

func pause():
	$AnimationPlayer.play('fade_in')
