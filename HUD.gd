extends CanvasLayer

signal start_game

export (bool) var is_joystick_enabled = true

func _ready():
	is_joystick_enabled = OS.has_touchscreen_ui_hint()
	print(is_joystick_enabled)
	$Joystick.hide()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the creeps"
	$Message.show()
	
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	if is_joystick_enabled:
		$Joystick.hide()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	if is_joystick_enabled:
		$Joystick.show()
	emit_signal("start_game")

