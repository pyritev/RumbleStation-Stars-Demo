extends Node

@onready var colors = [ # color themes are just an array of hex codes
	["#ffffff", "#00009D", "#008700", "#A4A4A4", "#3F3F3F", "#73000E", "#A17AFF", "#00E22F", "#670000", "#004000", "#FF7C2D", "#062B00", "#C02400", "#2E24FF", "#396A00"],
	["#ffffff", "#5bcefa", "#f5a9b8"],
	["#d52d00", "#ef7627", "#ff9a56", "#ffffff", "#d162a4", "#b55690", "#a30262"],
	["#711521", "#ffffff", "#c29b0c",  "#fdfbd4"],
	["#ffffff", "#4cdc48", "#009038"],
	["#ffffff", "#ff0000", "#00ff00", "#0000ff"], 
	["#ffffff"]
]
@onready var color_theme := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_theme(iterator := 1):
	if (color_theme + iterator) < colors.size() - 1 or (color_theme + iterator) >= 0:
		color_theme += iterator
	print(color_theme)
	SignalBus.theme_change.emit(iterator)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
