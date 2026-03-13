extends Node3D


const ERROR = preload("res://scenes/error/error.tscn")
const ERROR_BLUE = preload("res://scenes/error/error_blue.tscn")
const BLOOD = preload("res://scenes/main/blood.tres")
const CREATURE = preload("res://assets/country-road-creature-rig/source/Creature.fbx")


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
			$Noise/ErrorSFX.play()
			$Timer.start(clamp(1/(i+0.001), 0.05, 1.0))
			await $Timer.timeout
		
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
		await get_tree().create_timer(5).timeout
		$Dialogue.reset()


func _on_peek_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		$AnimationPlayer.play("peek")


func _on_run_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		$RunTrigger/Creature.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property($RunTrigger/Creature, "position", Vector3(80, 0, 20), 8)
		$RunTrigger/Creature/AnimationPlayer.play("road_creature_reference_skeleton|0500", -1, 2.0)
		await get_tree().create_timer(1.5).timeout
		$Noise/JumpscareSFX.play()
		tween.finished.connect(
			func():
				$RunTrigger/Creature.queue_free()
		)


func _on_attack_trigger_body_entered(body: Node3D) -> void:
	if body.name == "Car":
		
		
		$Noise/StaticSFX.volume_db = -60
		$Noise/StaticSFX.play()
		
		$AttackTrigger/Creature.visible = true
		$Car.can_move = false
		var tween = get_tree().create_tween()
		tween.tween_method(func(v): $Noise.material.set_shader_parameter("noise_intensity", v), 0.0, 0.2, 6).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($Noise/StaticSFX, "volume_db", -20, 6)
		tween.parallel().tween_property($AttackTrigger/Creature, "global_position", $Car.position + Vector3(0.0,0.0,4.0), 6)
		
		tween.tween_callback(func():
			$AttackTrigger/AnimationTree.get("parameters/playback").travel("A")
			$Car.picked_up = true
			$Car.monster_head = $AttackTrigger/Creature/road_creature_reference_skeleton/Skeleton3D/Head
			$Car.camera_anchor = $AttackTrigger/Creature/road_creature_reference_skeleton/Skeleton3D/Pin
			
			await get_tree().create_timer(1.0).timeout
			for i in range(50):
				for j in range(20):
					var sprite:Sprite3D = ERROR_BLUE.instantiate()
					sprite.position = Vector3(
						randf_range(-2, 2),
						randf_range(-2, 2),
						randf_range(-2, 0)
					)
					$Car/Neck/XPivot/Camera3D.add_child(sprite)
				$Noise/ErrorSFX.play()
				$Timer.start(clamp(1/(i+0.001), 0.05, 1.0))
				await $Timer.timeout
		)
		tween.tween_method(func(v): $Noise.material.set_shader_parameter("noise_intensity", v), 0.1, 0.5, 6).set_trans(Tween.TRANS_SINE)
		
		
		await get_tree().create_timer(13.0).timeout
		get_tree().change_scene_to_file("res://scenes/otherworld/otherworld.tscn")
