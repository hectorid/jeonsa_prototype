extends KinematicBody2D
class_name Player

const PROJ_SCN = preload("res://scenes/Projectile.tscn")

const FLOOR_NORMAL := Vector2(0,-1)
const GRAVITY : float = 800.0
const MAX_GRAVITY : float = 500.0 
const MOVE_SPEED : float = 100.0
const JUMP_FORCE : float = 250.0
const TARGET_INDICATOR_DISTANCE : int = 12

var velocity : Vector2

var is_falling : bool
var is_on_ceiling : bool
var is_on_floor : bool
var is_on_wall : bool

var target_direction : Vector2

func _ready() -> void:
	pass

func _physics_process(delta) -> void:
	var INPUT_MOVE_UP := Input.get_action_strength('move_up')
	var INPUT_MOVE_DOWN := Input.get_action_strength('move_down')
	var INPUT_MOVE_LEFT := Input.get_action_strength('move_left')
	var INPUT_MOVE_RIGHT := Input.get_action_strength('move_right')
	var INPUT_JUMP := Input.is_action_just_pressed("jump")
	var INPUT_SHOOT := Input.is_action_just_pressed("shoot")
	
	var input_direction := Vector2()
	input_direction.x = INPUT_MOVE_RIGHT - INPUT_MOVE_LEFT
	input_direction.y = INPUT_MOVE_DOWN - INPUT_MOVE_UP
	
	is_falling = velocity.y > 0
	is_on_ceiling = is_on_ceiling()
	is_on_floor = is_on_floor()
	is_on_wall = is_on_wall()
	
	velocity.x = input_direction.x * MOVE_SPEED
	
	velocity.y += GRAVITY * delta
	if velocity.y > MAX_GRAVITY:
		velocity.y = MAX_GRAVITY
	
	if (is_on_floor or (is_on_wall and is_falling)) and INPUT_JUMP:
		velocity.y = -JUMP_FORCE
	
	if velocity.x:
		$Sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	if input_direction:
		target_direction = input_direction.normalized()
		$TargetIndicator.position = target_direction * TARGET_INDICATOR_DISTANCE
	
	if INPUT_SHOOT:
		var proj = PROJ_SCN.instance()
		proj.global_position = global_position
		proj.direction = target_direction
		Game.spawn(proj)
	
	