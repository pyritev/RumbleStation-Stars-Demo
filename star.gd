extends Node2D

@export var speed : float
@export var angle : int
@onready var sprite = $Sprite2D
var velocity := Vector2.ZERO
@onready var speed_multiplier := 2.0
var corrected_angle : float
@onready var initial_position : Vector2
@onready var initial_screen_size : Vector2
@onready var behavior := "small"

@onready var current_color := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect all these fucking things
	SignalBus.speed_multiplier.connect(_on_speed_multiplier_changed)
	SignalBus.theme_change.connect(_on_theme_changed)
	SignalBus.timer_timed_out.connect(_on_timer_timeout)
	# set position and angle based on the stuff specified by the spawner
	position = initial_position
	corrected_angle = deg_to_rad(angle)
	# choose a random color from the current theme
	current_color = randi_range(0, Colors.colors[Colors.color_theme].size() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# move it
	velocity = Vector2(cos(corrected_angle), sin(corrected_angle)) * (speed * speed_multiplier)
	position += velocity * delta


func _on_area_2d_area_entered(_area):
	# spawn a new star with the same properties as the old one and kill
	SignalBus.spawn_new.emit(initial_position, initial_screen_size, behavior)
	queue_free()

func _on_speed_multiplier_changed(new_multiplier := 1):
	# set multiplier and update velocity
	speed_multiplier = new_multiplier
	velocity = Vector2(cos(corrected_angle), sin(corrected_angle)) * (speed * speed_multiplier)

func _on_theme_changed(iterator := 1):
	# stars originally handled the theme themselves it was really bad
	if not (Colors.color_theme + iterator) > Colors.colors.size() - 1 and not (Colors.color_theme + iterator) < 0:
		change_color(randi_range(0, Colors.colors[Colors.color_theme].size() - 1))

func change_color(value := -1):
	current_color = (current_color + 1 if current_color < Colors.colors[Colors.color_theme].size() - 1 else 0) if value == -1 else value
	sprite.modulate = Color.html(Colors.colors[Colors.color_theme][current_color])
	pass

func _on_timer_timeout():
	# the timer used to be attached to the star. why did i do that. now there's a global one
	change_color()
