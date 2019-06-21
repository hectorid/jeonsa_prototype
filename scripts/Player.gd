extends KinematicBody2D
class_name Player

const NONE = -1
const FLOOR_NORMAL = Vector2(0, -1)
const MAX_ATK_POWER = 3
const PROJ_SCN = preload("res://scenes/Projectile.tscn")

onready var atkPauseTimer : Timer = $Timers/AtkPause

const STATE = ["IDLE", "RUN", "JUMP", "FALL", "CHARGE", "ATTACK", "LATCH", "DEAD"]
enum {IDLE, RUN, JUMP, FALL, CHARGE, ATTACK, LATCH, DEAD}
var state : int = IDLE
var prev_state : int = state
var next_state : int = state

var vars : Dictionary = {}

var velocity : Vector2

var moving: bool = false
var on_floor : bool = false
var on_wall : bool = false

var target_direction := Vector2(1,0)

var charge : float = 0

func _physics_process(delta) -> void:
	vars = Config.get_section('player')

	on_floor = is_on_floor()
	on_wall = is_on_wall()

	process(delta)
#		#WALL SLIDE
#		if is_on_wall and velocity.y > 0:
#			velocity.y /= 2
#
#		# JUMP
#		var INPUT_JUMP := Input.is_action_just_pressed("jump")
#		if (is_on_floor or is_on_wall) and INPUT_JUMP:
#			velocity.y = -vars['jump_force']
#
#		# ATTACK
#		if move_direction:
#			target_direction = move_direction.normalized()
#	#		$TargetIndicator.position = target_direction * vars['inidicator_distance']
#
#		var INPUT_CHARGING := Input.is_action_pressed("shoot")
#		var INPUT_CHARGE_PRESS := Input.is_action_just_pressed("shoot")
#		var INPUT_CHARGE_RELEASE := Input.is_action_just_released("shoot")
#
#		is_charging = INPUT_CHARGING
#
#		if INPUT_CHARGING:
#			if INPUT_CHARGE_PRESS:
#				charge = 1
#
#			charge += vars['charge_rate'] * delta
#			if charge > MAX_ATK_POWER:
#				charge = MAX_ATK_POWER
#			print(charge)
#		else:
#			if INPUT_CHARGE_RELEASE:
#				atkPauseTimer.start(vars['atk_pause'])
#
#
#				var proj = PROJ_SCN.instance()
#				proj.global_position = global_position
#				proj.direction = target_direction
#				Game.spawn(proj)
#
#			charge = 0
#	else:
#		is_charging = false

func process(delta):
#	var INPUT_MOVE_UP := Input.get_action_strength("move_up")
#	var INPUT_MOVE_DOWN := Input.get_action_strength("move_down")
	var INPUT_MOVE_LEFT := Input.get_action_strength("move_left")
	var INPUT_MOVE_RIGHT := Input.get_action_strength("move_right")
	var INPUT_JUMP_PRESS:= Input.is_action_just_pressed("jump")
	var INPUT_ATTACK := Input.is_action_pressed("attack")
	var INPUT_ATTACK_PRESS := Input.is_action_just_pressed("attack")

	var move_direction := Vector2()

	move_direction.x = INPUT_MOVE_RIGHT - INPUT_MOVE_LEFT
#	move_direction.y = INPUT_MOVE_DOWN - INPUT_MOVE_UP

	moving = move_direction.x != 0

	var grav_modifier : float = 1.0
	var can_move : bool = true

	#STATES
	prev_state = state
	state = next_state

	var on_enter_state : bool = state != prev_state

	if on_enter_state:
		print(STATE[state])
	match state:
		IDLE:
			$AnimPlayer.switch('idle')

			if INPUT_ATTACK_PRESS:
				next_state = CHARGE
			elif INPUT_JUMP_PRESS or velocity.y < 0:
				next_state = JUMP
			elif moving:
				next_state = RUN
		RUN:
			$AnimPlayer.switch('run')

			if INPUT_ATTACK_PRESS:
				next_state = CHARGE
			elif INPUT_JUMP_PRESS or velocity.y < 0:
				next_state = JUMP
			elif not moving:
				next_state = IDLE
		JUMP:
			if on_enter_state:
				velocity.y = -vars['jump_force']

			$AnimPlayer.switch('jump')

			if INPUT_ATTACK_PRESS:
				next_state = CHARGE
			elif velocity.y >= 0:
				next_state = FALL
		FALL:
			$AnimPlayer.switch('fall')

			if INPUT_ATTACK_PRESS:
				next_state = CHARGE
			elif on_wall:
				next_state = LATCH
			elif on_floor:
				next_state = IDLE
		CHARGE:
			$AnimPlayer.switch('charge')

			can_move = false

			if not INPUT_ATTACK:
				next_state = ATTACK
		ATTACK:
			$AnimPlayer.switch('attack')

			can_move = false

			next_state = IDLE
		LATCH:
			$AnimPlayer.switch('latch')

			grav_modifier = 0.5

			if on_wall and velocity.y > 0:
				velocity.y = 0

			if INPUT_JUMP_PRESS:
				next_state = JUMP
			elif not on_wall:
				next_state = FALL
			
			if on_floor:
				next_state = IDLE

	if velocity.x:
		$Sprite.flip_h = velocity.x < 0

	#HORIZONTAL MOVEMENT
	if can_move:
		velocity.x = move_direction.x * vars['move_speed']
	elif on_floor:
		velocity.x = 0

	# GRAVITY
	velocity.y += vars['gravity'] * delta
	if velocity.y > vars['max_gravity']:
		velocity.y = vars['max_gravity']

	# APPLY MOVEMENT
	velocity = move_and_slide(velocity, FLOOR_NORMAL)