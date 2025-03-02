extends Node2D
var speed_multiplier := 2.0
@onready var timer = $Timer
@onready var wait_time = 0.4
@onready var star_scale := SignalBus.star_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in round(30 * star_scale):
		SignalBus.spawn_new.emit(Vector2.ZERO, get_viewport().get_visible_rect().size, "small")
	for x in round(5 * star_scale):
		SignalBus.spawn_new.emit(Vector2.ZERO, get_viewport().get_visible_rect().size, "medium")
	for x in round(5 * star_scale):
		SignalBus.spawn_new.emit(Vector2.ZERO, get_viewport().get_visible_rect().size, "medium_45")
	for x in round(5 * star_scale):
		SignalBus.spawn_new.emit(Vector2.ZERO, get_viewport().get_visible_rect().size, "xmedium_45")
	for x in round(5 * star_scale):
		SignalBus.spawn_new.emit(Vector2.ZERO, get_viewport().get_visible_rect().size, "large_45")
	for x in round(5 * star_scale):
		SignalBus.spawn_new.emit(Vector2.ZERO, get_viewport().get_visible_rect().size, "large_45_tilted")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("speed_up"):
		speed_multiplier += 1
		SignalBus.speed_multiplier.emit(speed_multiplier)
		print("Speed multiplier set to " + str(speed_multiplier))
		$Timer.start(wait_time / speed_multiplier)
	if Input.is_action_just_pressed("speed_down") and speed_multiplier > 1:
		speed_multiplier -= 1
		SignalBus.speed_multiplier.emit(speed_multiplier)
		$Timer.start(wait_time / speed_multiplier)
		print("Speed multiplier set to " + str(speed_multiplier))
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("color_left"):
		if Colors.color_theme != 0:
			Colors.change_theme(-1)
	if Input.is_action_just_pressed("color_right"):
		if not Colors.color_theme == Colors.colors.size() - 1:
			Colors.change_theme(1)
	if Input.is_action_just_pressed("scale_down") and star_scale >= 1:
		SignalBus.star_scale -= 0.5
		print("star scale set to " + str(SignalBus.star_scale))
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("scale_up"):
		SignalBus.star_scale += 0.5
		print("star scale set to " + str(SignalBus.star_scale))
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("scale_reset"):
		SignalBus.star_scale = 1.0
		print("star scale set to " + str(SignalBus.star_scale))
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass


func _on_timer_timeout():
	SignalBus.timer_timed_out.emit()
	# scale wait time to speed multiplier
	var new_time = wait_time / speed_multiplier
	$Timer.start(new_time)
	
