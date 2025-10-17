class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
	print("Area entered: ", area.name, " (Type: ", area.get_class(), ")") # Debug 1
	
	var hit_component = area as HitComponent
	
	# Debug 2: Cek apakah hit_component berhasil di-cast
	if hit_component == null:
		print("Error: Area '", area.name, "' does not have a HitComponent.")
		return # Keluar dari fungsi jika tidak ada HitComponent
	
	print("HurtComponent's required tool: ", tool) # Debug 3
	print("HitComponent's current tool: ", hit_component.current_tool) # Debug 4
	
	if tool == hit_component.current_tool: 
		print("Tools MATCH! Emitting hurt signal with damage: ", hit_component.hit_damage) # Debug 5
		hurt.emit(hit_component.hit_damage)
	else:
		print("Tools MISMATCH. Hurt not triggered.") # Debug 6
