extends Node2D

var obstacles_array:Array = ["res://Scenes/Obstacles/obstacle_one.tscn","res://Scenes/Obstacles/obstacle_two.tscn","res://Scenes/Obstacles/obstacle_three.tscn","res://Scenes/Obstacles/obstacle_four.tscn"]

func _ready():
	$AudioStreamPlayer.play()
	load_game()
	

func _process(_delta):
	$CanvasLayer/VBoxContainer/HighScore.text = "High Score: " + str(Globals.high_score)
	if Input.is_action_just_pressed("Jump") and Globals.game_started == false:
		start_game()
	$CanvasLayer/VBoxContainer/Score.text = "Score: " + str(Globals.score)
	

func _on_player_player_died():
	Globals.game_started = false
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
	if Globals.game_started == false:
		Globals.game_started = true
		$CanvasLayer/VBoxContainer2.queue_free()

func load_game():
	var file = FileAccess.open("res://save.txt", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		Globals.high_score = int(content)
	else:
		var save = FileAccess.open("res://save.txt", FileAccess.WRITE)
		save.store_string(str(0))


func _on_player_spawn_obstacle():
	var obstacle_choice = obstacles_array.pick_random()
	var new_obstacle:Node2D = load(obstacle_choice).instantiate()
	if !$SpawnedObstacles.get_children():
		new_obstacle.global_position.x = $SpawnPoint.global_position.x
		$SpawnedObstacles.add_child(new_obstacle)
		$SpawnPoint.position.x = new_obstacle.position_x
		
	else:
		new_obstacle.global_position.x = $SpawnPoint.global_position.x
		$SpawnedObstacles.add_child(new_obstacle)
		$SpawnPoint.position.x = new_obstacle.position_x
	if $AudioStreamPlayer.pitch_scale < 1.5:
		$AudioStreamPlayer.pitch_scale += .005
	else: 
		$AudioStreamPlayer.pitch_scale = 1.5
		
