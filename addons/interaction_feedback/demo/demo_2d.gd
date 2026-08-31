extends Node2D

@onready var _cards: Node2D = $Cards


func _ready() -> void:
	get_viewport().size_changed.connect(_center)
	_center()


func _center() -> void:
	_cards.global_position.x = get_viewport_rect().size.x * 0.5
