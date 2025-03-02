extends Node
signal spawn_new(position, initial_screen, behavior)
signal speed_multiplier(new_multiplier)
signal theme_change(amount)
signal timer_timed_out()

var star_scale := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_star_scale(iterator):
	star_scale += iterator

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
