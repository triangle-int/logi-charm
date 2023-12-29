@tool

extends Node2D

@export var chain_node: PackedScene
@export var node_length: float
@export var radius: float

func _ready():
	var node_count = floor(radius * TAU / node_length) as int
	
	if node_count % 2 == 1:
		node_count += 1

	for index in range(node_count):
		var angle = (index as float) / node_count * TAU
		var node = chain_node.instantiate() as Sprite2D
		node.position = Vector2(cos(angle), -sin(angle)) * radius
		node.rotation = -angle
		node.frame = index % 2
		node.z_index = index % 2
		add_child(node)
