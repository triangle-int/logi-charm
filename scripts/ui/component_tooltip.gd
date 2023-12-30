extends Node2D

@export var header: String
@export var width: int
@export_multiline var description: String

@onready var header_label = $Background/Header
@onready var width_label = $Background/Width
@onready var description_label = $Background/Description

func _ready():
	header_label.text = header
	width_label.text = "Width: " + str(width)
	description_label.text = description
