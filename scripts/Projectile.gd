extends Area2D
class_name Projectile

const SPEED = 175

var direction : Vector2 = Vector2(1,0)

func init(input_pos : Vector2, input_dir : Vector2):
	global_position = input_pos
	direction = input_dir

func _physics_process(delta):
 translate(direction * SPEED * delta)

func _on_body_entered(body):
	if body.is_in_group('wall'):
		queue_free()
