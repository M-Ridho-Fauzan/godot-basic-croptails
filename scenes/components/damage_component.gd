class_name DamageComonent
extends Node2D

@export var max_damege = 1
@export var current_damage = 0

signal max_damaged_reached

func apply_damage(damage: int) -> void:
	current_damage = clamp(current_damage + damage, 0, max_damege)
	
	if current_damage == max_damege:
		max_damaged_reached.emit()
