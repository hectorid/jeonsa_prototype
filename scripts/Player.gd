extends KinematicBody2D
class_name Player

const FLOOR_NORMAL = Vector2(0, -1)
const PROJ_SCN = preload("res://scenes/Projectile.tscn")

var vars : Dictionary = {}

var velocity : Vector2

var is_dead : bool
var is_hit : bool
var is_attacking : bool
var is_moving: bool
var is_falling : bool
var is_on_ceiling : bool
var is_on_floor : bool
var is_on_wall : bool

var target_direction := Vector2(1,0)

func _physics_process(delta) -> void:
	vars = Config.get_section('player')

	var INPUT_MOVE_UP := Input.get_action_strength('move_up')
	var INPUT_MOVE_DOWN := Input.get_action_strength('move_down')
	var INPUT_MOVE_LEFT := Input.get_action_strength('move_left')
	var INPUT_MOVE_RIGHT := Input.get_action_strength('move_right')
	var INPUT_JUMP := Input.is_action_just_pressed("jump")
	var INPUT_SHOOT := Input.is_action_just_pressed("shoot")

	var input_direction := Vector2()
	input_direction.x = INPUT_MOVE_RIGHT - INPUT_MOVE_LEFT
	input_direction.y = INPUT_MOVE_DOWN - INPUT_MOVE_UP

	is_moving = input_direction.x != 0
	is_falling = velocity.y > 0
	is_on_ceiling = is_on_ceiling()
	is_on_floor = is_on_floor()
	is_on_wall = is_on_wall()

	velocity.x = input_direction.x * vars['move_speed']

	velocity.y += vars['gravity'] * delta
	if velocity.y > vars['max_gravity']:
		velocity.y = vars['max_gravity']

	if (is_on_floor or is_on_wall) and INPUT_JUMP:
		velocity.y = -vars['jump_force']

	if velocity.x:
		$Sprite.flip_h = velocity.x < 0

	velocity = move_and_slide(velocity, FLOOR_NORMAL)

	if input_direction:
		target_direction = input_direction.normalized()
#		$TargetIndicator.position = target_direction * vars['inidicator_distance']

	if INPUT_SHOOT:
		var proj = PROJ_SCN.instance()
		proj.global_position = global_position
		proj.direction = target_direction
		Game.spawn(proj)
		
	#ANIMATION
	if is_dead:
		$AnimPlayer.switch('death')
	elif is_hit:
		$AnimPlayer.switch('hit')
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
		elif is_falling or is_on_wall:
			$AnimPlayer.switch('fall')
		else:
			$AnimPlayer.switch('jump')