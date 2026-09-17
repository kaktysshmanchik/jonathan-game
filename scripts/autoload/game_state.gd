extends Node

var cards_found: Array[int] = []

var giggles_complete: bool = false
var living_room_complete: bool = false
var shooter_complete: bool = false
var map_complete: bool = false


func reset_game() -> void:
	cards_found.clear()
	giggles_complete = false
	living_room_complete = false
	shooter_complete = false
	map_complete = false
