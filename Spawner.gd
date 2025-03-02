extends Node2D

@export var spawn_scene : PackedScene
@export var speed : float
# @export_enum("small", "medium", "medium_45", "large", "large_45", "large_45_tilted") var behavior := "small"
var random = RandomNumberGenerator.new()
var speed_multiplier := 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	SignalBus.spawn_new.connect(_on_called)
	SignalBus.speed_multiplier.connect(_on_speed_multiplier_changed)
	do_spawn()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func do_spawn(pos := Vector2.ZERO, initial_screen_size := get_viewport().get_visible_rect().size, behavior := "small"):
	var new_particle = spawn_scene.instantiate()
	# get current pixel accurate screen size
	var screen_size = get_viewport().get_visible_rect().size
	# star positioning
	if pos == Vector2.ZERO or initial_screen_size != screen_size: # automatic behavior - also happens if screen size changes
		if behavior == "small" || behavior == "medium" || behavior == "large": # stars that go straight down
			new_particle.initial_position.y = self.position.y - randi_range(0, screen_size.y)
			new_particle.initial_position.x = randi_range(0, screen_size.x)
		elif behavior == "medium_45" || behavior == "xmedium_45" || behavior == "large_45_tilted": # stars that come from the left of the screen
			new_particle.initial_position.y = -randi_range(16, screen_size.y)
			new_particle.initial_position.x = randi_range(-screen_size.x, screen_size.x/1.25)
		else: # stars that come from the right of the screen
			new_particle.initial_position.y = -randi_range(16, screen_size.y)
			new_particle.initial_position.x = randi_range(screen_size.x/1.25, screen_size.x * 2)
	else: # respawn behavior: retaion original x position but spawn at the top of the screen (this works don't worry about it)
		new_particle.initial_position.x = pos.x
		new_particle.initial_position.y = -16
	# evil and intimidating ternary statement to determine angle
	new_particle.angle = 90 if ["small", "medium", "large"].has(behavior) else randi_range(40, 80) if ["medium_45", "large_45_tilted", "xmedium_45"].has(behavior) else randi_range(105, 145)
	# speed is vibes based
	new_particle.speed = speed if behavior == "small" else speed * 3
	# save screen size to star
	new_particle.initial_screen_size = screen_size
	add_child(new_particle)
	# save other things to star
	new_particle.behavior = behavior
	new_particle.speed_multiplier = speed_multiplier
	# set the sprite frame based on behavior
	new_particle.sprite.frame = 3 if behavior == "small" else 4 if ["medium", "medium_45"].has(behavior) else 1 if behavior == "xmedium_45" else 0 if ["large", "large_45"].has(behavior) else 2
	pass

func _on_called(pos:= Vector2.ZERO, initial_screen_size := get_viewport().get_visible_rect().size, behavior := "small"):
	# this made sense before but i ended up moving one of the duties of this function somewhere else later on so now it's pointless
	do_spawn(pos, initial_screen_size, behavior)

func _on_speed_multiplier_changed(new_multiplier := 1):
	speed_multiplier = new_multiplier
