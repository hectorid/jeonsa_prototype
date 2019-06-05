extends KinematicBody2D
class_name Player

const FLOOR_NORMAL = Vector2(0, -1)
const MAX_ATK_POWER = 3
const PROJ_SCN = preload("res://scenes/Projectile.tscn")

var vars : Dictionary = {}

var velocity : Vector2

var is_dead : bool
var is_hit : bool
var is_charging : bool
var is_attacking : bool
var is_moving: bool
var is_falling : bool

var is_on_floor : bool
var is_on_wall : bool

var target_direction := Vector2(1,0)

var energy : float = 0
var charge : float = 0

func _physics_process(delta) -> void:
	vars = Config.get_section('player')

	var INPUT_MOVE_UP := Input.get_action_strength('move_up')
	var INPUT_MOVE_DOWN := Input.get_action_strength('move_down')
	var INPUT_MOVE_LEFT := Input.get_action_strength('move_left')
	var INPUT_MOVE_RIGHT := Input.get_action_strength('move_right')

	var move_direction := Vector2()
	
	move_direction.x = INPUT_MOVE_RIGHT - INPUT_MOVE_LEFT
	move_direction.y = INPUT_MOVE_DOWN - INPUT_MOVE_UP

	is_moving = move_direction.x != 0
	is_falling = velocity.y > 0
	
	is_on_floor = is_on_floor()
	is_on_wall = is_on_wall()
	
	if not (is_dead or is_hit):
		#HORIZONTAL MOVEMENT
		if not is_charging and not is_attacking:
			velocity.x = move_direction.x * vars['move_speed']
	
		# GRAVITY
		velocity.y += vars['gravity'] * delta
		if velocity.y > vars['max_gravity']:
			velocity.y = vars['max_gravity']
	
		# JUMP
		var INPUT_JUMP := Input.is_action_just_pressed("jump")
		if (is_on_floor or is_on_wall) and INPUT_JUMP:
			velocity.y = -vars['jump_force']
	
		# SHOOT
		if move_direction:
			target_direction = move_direction.normalized()
	#		$TargetIndicator.position = target_direction * vars['inidicator_distance']
		
		var INPUT_CHARGING := Input.is_action_pressed("shoot")
		var INPUT_CHARGE_PRESS := Input.is_action_just_pressed("shoot")
		var INPUT_CHARGE_RELEASE := Input.is_action_just_released("shoot")
		
		if INPUT_CHARGING:
			if INPUT_CHARGE_PRESS:
				charge = 1
			
			charge += vars['charge_rate'] * delta
			if charge > MAX_ATK_POWER:
				charge = MAX_ATK_POWER
			print(charge)
		else:
			if INPUT_CHARGE_RELEASE:
				var proj = PROJ_SCN.instance()
				proj.global_position = global_position
				proj.direction = target_direction
				Game.spawn(proj)
			
			charge = 0
	
	
	# APPLY MOVEMENT
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	
	#ANIMATION
	if velocity.x:
		$Sprite.flip_h = velocity.x < 0
	
	if is_dead:
		$AnimPlayer.switch('death')
	elif is_hit:
		$AnimPlayer.switch('hit')
	elif is_charging:
			$AnimPlayer.switch('charge')
	elif is_on_floor:
		if is_attacking:
			$AnimPlayer.switch('atk_ground')
		elif is_moving:
			$AnimPlayer.switch('run')
		else:
			$AnimPlayer.switch('idle')
	else:
		if is_attacking:
			$AnimPlayer.switch('atk_air')
		elif is_falling:
			$AnimPlayer.switch('fall')
		else:
			$AnimPlayer.switch('jump')