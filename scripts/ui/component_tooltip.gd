extends Node2D

@export var header: String
@export var width: int
@export_multiline var description: String

@onready var header_label = $PanelContainer/VBoxContainer/Header
@onready var width_label = $PanelContainer/VBoxContainer/Width
@onready var description_label = $PanelContainer/VBoxContainer/Description

func _ready():
	header_label.text = header
	width_label.text = "Width: " + str(width)
	description_label.text = description
