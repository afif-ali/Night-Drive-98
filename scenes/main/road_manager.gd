@tool
extends Node3D

const ROAD_MESH:PackedScene = preload("res://assets/psx-road/source/road-module.blend")

var modules:Array[Node3D]

const RENDER_DIST = 4

func _ready() -> void:
	modules.resize(RENDER_DIST)
	for i in range(RENDER_DIST):
		modules[i] = create_chunk(i)
		add_child(modules[i])

func _process(_delta:float) -> void:
	if modules[1].position.z < get_tree().get_first_node_in_group("controller").position.z:
		modules[0].queue_free()
		modules.pop_front()
		var new_pos:int = int(modules[-1].position.z/80)+1
		modules.push_back(create_chunk(new_pos))
		add_child(modules[-1])
	if modules[0].position.z > get_tree().get_first_node_in_group("controller").position.z:
		modules[-1].queue_free()
		modules.pop_back()
		var new_pos:int = int(modules[0].position.z/80)-1
		modules.push_front(create_chunk(new_pos))
		add_child(modules[0])

func create_chunk(pos:int)->Node3D:
	var mesh:Node3D = ROAD_MESH.instantiate()
	mesh.position = Vector3(0,0,pos*80)
	return mesh
