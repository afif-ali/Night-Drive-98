extends Control


@onready var label = $MarginContainer/Label

func _ready() -> void:
	reset()

func say(text:String):
	for i in range(text.length()):
		label.text = text.substr(0, i+1)
		$AudioStreamPlayer.play()
		await get_tree().create_timer(0.05).timeout

func reset():
	label.text = ""
