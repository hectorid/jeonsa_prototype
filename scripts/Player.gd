extends KinematicBody2D
class_name Player

const PROJ_SCN = preload("res://scenes/Projectile.tscn")

var velocity : Vector2

var is_falling : bool
var is_on_ceiling : bool
var is_on_floor : bool
var is_on_wall : bool

var target_direction : Vector2

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
	
	velocity.x = input_direction.x * VAR.PLAYER_MOVE_SPEED
	
	velocity.y += VAR.PLAYER_GRAVITY * delta
	if velocity.y > VAR.PLAYER_MAX_GRAVITY:
		velocity.y = VAR.PLAYER_MAX_GRAVITY
	
	if (is_on_floor or (is_on_wall and is_falling)) and INPUT_JUMP:
		velocity.y = -VAR.PLAYER_JUMP_FORCE
	
	if velocity.x:
		$Sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity, VAR.FLOOR_NORMAL)
	
	if input_direction:
		target_direction = input_direction.normalized()
#		$TargetIndicator.position = target_direction * VAR.PLAYER_INDICATOR_DISTANCE
	
	if INPUT_SHOOT:
		var proj = PROJ_SCN.instance()
		proj.global_position = global_position
		proj.direction = target_direction
		Game.spawn(proj)
	
	