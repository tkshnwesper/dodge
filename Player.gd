extends Area2D

signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var screen_size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity
	
	if $"../HUD".is_joystick_enabled:
		velocity = $"../HUD/Joystick".output
	else:
		velocity = Vector2()
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	$AnimatedSprite.animation = "walk"
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	if velocity.y < 0:
		$AnimatedSprite.flip_v = true
	else:
		$AnimatedSprite.flip_v = false
	


func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
