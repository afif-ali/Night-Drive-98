@tool
extends Node3D

const ROAD_MESH:Mesh = preload("res://assets/psx-road/source/road-module.obj")
const DEFAULT_MATERIAL:StandardMaterial3D = preload("res://assets/psx-road/default_material.tres")

var modules:Array[MeshInstance3D]
var materials:Array[int]

const RENDER_DIST = 20

func _ready() -> void:
	add_chunk_index(0, RENDER_DIST)
	add_chunk_index(1, 20)
	print(materials)
	
	modules.resize(RENDER_DIST*2+1)
	for i in range(RENDER_DIST*2+1):
		modules[i] = create_chunk(i-RENDER_DIST)
		add_child(modules[i])

func _process(_delta:float) -> void:
	if modules[RENDER_DIST].position.z < get_tree().get_first_node_in_group("controller").position.z:
		modules[0].queue_free()
		modules.pop_front()
		var new_pos:int = int(modules[-1].position.z/9)+1
		modules.push_back(create_chunk(new_pos))
		add_child(modules[-1])
	if modules[RENDER_DIST].position.z > get_tree().get_first_node_in_group("controller").position.z:
		modules[-1].queue_free()
		modules.pop_back()
		var new_pos:int = int(modules[0].position.z/9)-1
		modules.push_front(create_chunk(new_pos))
		add_child(modules[0])

func create_chunk(pos:int)->MeshInstance3D:
	var mesh:MeshInstance3D = MeshInstance3D.new()
	mesh.mesh = ROAD_MESH
	mesh.position = Vector3(0,0,pos*9)
	mesh.create_trimesh_collision()
	
	if pos+RENDER_DIST >=0 and pos+RENDER_DIST < materials.size():
		if materials[pos+RENDER_DIST] == 1:
			mesh.material_override = DEFAULT_MATERIAL
	
	return mesh

func add_chunk_index(index:int, amount:int):
	for i in range(amount):
		materials.push_back(index)
