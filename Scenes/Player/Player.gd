extends CharacterBody2D

signal player_died
signal spawn_obstacle()
@onready var anim:AnimatedSprite2D = $Squid

var initial_pos = position.x
var current_pos: float
var speed = Globals.player_speed
var jump_velocity: float = -600.0
var double_jumped: bool = true
var open_to_collision: bool = false
var running: bool = false
var game_start = Globals.game_started
var going_left: bool = false
var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')
var direction: int = 1
var dead: bool = false
var speed_rate_increase: float = .025
var max_speed: float = 900

func _process(delta):
	if game_start == true:
		if speed == max_speed:
			$CPUParticles2D.emitting = true
		current_pos = position.x
		if (current_pos - initial_pos) >= 600:
			if speed > 750:
				anim.play('run')
			if speed <= max_speed:
				if (speed + speed * speed_rate_increase) > max_speed:
					speed = max_speed
				else:
					speed += speed * speed_rate_increase
			spawn()
		#Turn if hit wall
		if velocity.x == 0 and open_to_collision and !dead:
			dead = true
			die("collision")
		velocity.x = speed * direction
		#Activate gravity while in air
		if not is_on_floor():
			velocity.y += gravity * delta
			if not double_jumped and !dead:
				anim.play('jump')
		#Jumping Logic
		if (Input.is_action_just_pressed("Jump")) and is_on_floor() and !dead:
			jump()

		if (Input.is_action_just_pressed("Jump")) and not is_on_floor() and not double_jumped and !dead:
			double_jump()

		#Reset Double Jump
		if is_on_floor() and not dead:
			double_jumped = false
			#if running:
				#anim.play('run')
			
			if speed > 750:
				anim.play('run')
			else:
				anim.play('walk')

		##Activate Run
		#if (Input.is_action_just_pressed("Run")):
			#run()

		move_and_slide()
	else:
		velocity.x = 1
		game_start = Globals.game_started


func jump():
	velocity.y = jump_velocity
	$JumpSound.play()
	$JumpSound.pitch_scale = 1.0
	anim.play('jump')
	
	

func double_jump():
	double_jumped = true
	anim.play('rotate')
	$JumpSound.play()
	$JumpSound.pitch_scale = 4.0
	velocity.y = .75 * jump_velocity

#func turn():
	#$CPUParticles2D.direction = $CPUParticles2D.direction * -1
	#going_left = !going_left
	#if going_left:
		#anim.flip_h = 1
		#direction = -1
	#else:
		#anim.flip_h = 0
		#direction = 1
	#open_to_collision = false
	#$CollisionTimer.start()

func _on_collision_timer_timeout():
	open_to_collision = true

#func run():
	#running = !running
	#if running:
		#$CPUParticles2D.emitting = true
		#speed = 2 * speed
	#else:
		#$CPUParticles2D.emitting = false
		#speed = speed / 2



func _on_visible_on_screen_notifier_2d_screen_exited():
	die("offscreen")


#func _on_wait_timer_timeout():
	#velocity.x = 1
	#game_start = true
	
func die(method):
	$DeathSound.play()
	if Globals.score >= Globals.high_score:
		Globals.high_score = Globals.score
	if method == "collision":
		speed = 0
		gravity = 0
		velocity = Vector2(0,0)
		$CPUParticles2D.emitting = false
		anim.play('die')
	elif method == "offscreen":
		speed = 0
		$CPUParticles2D.emitting = false
		player_died.emit()



func _on_squid_animation_finished():
	if anim.animation == "die":
		player_died.emit()
	elif not is_on_floor():
		anim.play('jump')

func spawn():
	initial_pos = position.x
	Globals.score += 500
	spawn_obstacle.emit()
