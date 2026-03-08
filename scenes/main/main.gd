extends Node3D


const BLUE_ERROR = preload("res://scenes/error/blue_error/blue_error.tscn")
const RED_ERROR = preload("res://scenes/error/red_error/red_error.tscn")


func _process(delta: float) -> void:
	$DebugScreen/Label.text = str($Car.position)

func _on_intro_text_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		print("boom")
		$Dialogue.say("Its starting to get dark out ...")
		await get_tree().create_timer(4).timeout
		$Dialogue.say("I should head home .")
		await get_tree().create_timer(6).timeout
		$Dialogue.reset()

func _on_world_morph_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		var tween = get_tree().create_tween()
		tween.tween_property($WorldEnvironment.environment, "fog_light_color", Color.BLACK, 5).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($WorldEnvironment.environment, "ambient_light_color", Color8(255, 130, 120), 5)
		tween.parallel().tween_property($DirectionalLight3D, "light_energy", 0.2, 5)
		
		for i in range(80):
			for j in range(20):
				var sprite:Sprite3D = BLUE_ERROR.instantiate()
				sprite.position = Vector3(
					randf_range(-2, 2),
					randf_range(0, 2),
					randf_range(-1, 3)
				)
				$Car/ErrorContainer.add_child(sprite)
			$ErrorSFX.play()
			await get_tree().create_timer(clamp(1/(i+0.001), 0.05, 1.0)).timeout
			
		for i in range($Car/ErrorContainer.get_child_count()):
			$Car/ErrorContainer.get_child(i).queue_free()
