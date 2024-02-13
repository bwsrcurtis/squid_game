extends Node2D

var obstacles_array:Array = ["res://Scenes/Obstacles/obstacle_one.tscn","res://Scenes/Obstacles/obstacle_two.tscn"]

func _ready():
	$AudioStreamPlayer.play()
	load_game()
	

func _process(_delta):
	$CanvasLayer/VBoxContainer/HighScore.text = "High Score: " + str(Globals.high_score)
	if Input.is_action_just_pressed("Jump") and Globals.game_started == false:
		start_game()
	$CanvasLayer/VBoxContainer/Score.text = "Score: " + str(Globals.score)
	

func _on_player_player_died():
	get_tree().reload_current_scene()
	Globals.score = 0
	var save = FileAccess.open("res://save.txt", FileAccess.WRITE)
	save.store_string(str(Globals.high_score))

func _on_animation_player_animation_finished(_fade_in):
	get_tree().paused = false

func pause():
	$AnimationPlayer.play('fade_in')

func _on_button_pressed():	
	start_game()

func start_game():
	Globals.game_started = true
	$CanvasLayer/Button.queue_free()

func load_game():
	var file = FileAccess.open("res://save.txt", FileAccess.READ)
	var content = file.get_as_text()
	Globals.high_score = int(content)


func _on_player_spawn_obstacle(marker_pos_x):
	var obstacle_choice = obstacles_array.pick_random()
	var new_obstacle:Node2D = load(obstacle_choice).instantiate()
	if !$Node2D.get_children():
		new_obstacle.global_position.x = marker_pos_x - 32
		print(new_obstacle.position.x)
		$Node2D.add_child(new_obstacle)
		print(marker_pos_x)
	elif $Node2D.get_children().size() == 1:
		new_obstacle.global_position.x = marker_pos_x + 610
		print(new_obstacle.position.x)
		$Node2D.add_child(new_obstacle)
		print(marker_pos_x)
		
	else:
		new_obstacle.global_position.x = marker_pos_x + 930
		print(new_obstacle.position.x)
		$Node2D.add_child(new_obstacle)
		print(marker_pos_x)
		
