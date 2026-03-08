extends Node3D


const ERROR = preload("res://scenes/error/error.tscn")
const BLOOD = preload("res://scenes/main/blood.tres")


func _process(delta: float) -> void:
	$DebugScreen/Label.text = str($Car.position)

func _on_intro_text_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		$Dialogue.say("Its starting to get dark out ...")
		await get_tree().create_timer(4).timeout
		$Dialogue.say("I should head home .")
		await get_tree().create_timer(6).timeout
		$Dialogue.reset()

func _on_world_morph_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		var tween = get_tree().create_tween()
		tween.tween_property($WorldEnvironment.environment, "fog_light_color", Color.BLACK, 7).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($WorldEnvironment.environment, "ambient_light_color", Color8(255, 130, 120), 7)
		tween.parallel().tween_property($DirectionalLight3D, "light_energy", 0.2, 7)
		tween.parallel().tween_method(
			func(v): BLOOD.set_shader_parameter("intensity", v),
			0.0, 0.5, 5.0
		)
		
		for i in range(50):
			for j in range(20):
				var sprite:Sprite3D = ERROR.instantiate()
				sprite.position = Vector3(
					randf_range(-2, 2),
					randf_range(0, 2),
					randf_range(-1, 3)
				)
				$Car/ErrorContainer.add_child(sprite)
			$ErrorSFX.play()
			await get_tree().create_timer(clamp(1/(i+0.001), 0.05, 1.0)).timeout
		
		$Car.can_move = false
		$Noise.material.set_shader_parameter("noise_intensity", 1.0)
		$Noise/StaticSFX.play()
		for i in range($Car/ErrorContainer.get_child_count()):
			$Car/ErrorContainer.get_child(i).queue_free()
		$Car/EngineSFX.pitch_scale = 0.35
		await get_tree().create_timer(1).timeout
		
		$Noise.material.set_shader_parameter("noise_intensity", 0.0)
		$Noise/StaticSFX.stop()
		await get_tree().create_timer(2).timeout
		$Car.can_move = true

		$Dialogue.say("What the hell is going on...")
		await get_tree().create_timer(2).timeout
		$Dialogue.reset()


func _on_peek_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		$AnimationPlayer.play("peek")
