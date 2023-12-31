class_name BaseChainGenerator

extends Node

@export var chain_node: PackedScene
@export var node_length: float

var count = 0

func spawn_chain(position: Vector2, rotation: float, parent: Node2D = null):
	var node = chain_node.instantiate() as Sprite2D
	parent = parent if parent else self
	parent.add_child(node)
	node.position = position
	node.rotation = rotation
	node.frame = count % 2
	node.z_index = count % 2 - 1
	
	count += 1

func clear():
	for child in get_children():
		child.queue_free()
	
	count = 0
