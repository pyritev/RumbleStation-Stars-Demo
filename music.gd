extends Node2D
@onready var music = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("music"):
		if music.playing:
			music.stop()
		else:
			music.play()
	pass
