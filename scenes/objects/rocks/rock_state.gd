extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComonent = $DamageComponent

# --- Tambahan Kode Baru untuk input di editor ---
@export_range(0, 100, 1, "suffix:%") var stone_drop_chance: int = 10 # Persentase kemungkinan stone akan jatuh (0-100)
@export_range(1, 10, 1) var max_stones_to_drop: int = 3        # Jumlah maksimum stone yang bisa jatuh

@export var initial_dispersion_radius: float = 1.0 # Radius kecil untuk offset awal, bisa 0 jika tidak mau
# --- Akhir Tambahan Kode Baru ---

var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	await get_tree().create_timer(0.4).timeout
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)
	
	## --- Perubahan di sini ---
	## Pastikan material ada dan bertipe ShaderMaterial
	#if material is ShaderMaterial:
		#var shader_material = material as ShaderMaterial # Casting eksplisit
		#shader_material.set_shader_parameter("shake_intensity", 0.5)
		#await get_tree().create_timer(1.0).timeout
		#shader_material.set_shader_parameter("shake_intensity", 0.0)
	#else:
		## Opsional: Cetak peringatan jika material tidak diatur dengan benar
		#push_warning("Material pada %s bukan ShaderMaterial atau belum diatur." % name)
	## --- Akhir Perubahan ---

func on_max_damage_reached() -> void: 
	call_deferred("add_stone_scene")
	queue_free()

func add_stone_scene() -> void: 
	#var stone_instance = stone_scene.instantiate() as Node2D
	#stone_instance.global_position = global_position
	#get_parent().add_child(stone_instance)
		# --- Modifikasi di sini ---
	var actual_drop_chance = stone_drop_chance
	var actual_max_stones = max_stones_to_drop

	if randi_range(1, 100) <= actual_drop_chance:
		var num_stones_to_drop = randi_range(1, actual_max_stones)
		print("Dropping %d stones with a %d%% chance." % [num_stones_to_drop, actual_drop_chance])

		for i in range(num_stones_to_drop):
			var stone_instance = stone_scene.instantiate() as Node2D # Ini akan menjadi RigidBody2D
			
			# Tambahkan sedikit offset awal untuk membantu fisika agar tidak terlalu menumpuk di 0,0
			# Ini opsional; jika 0, semua stone akan spawn persis di global_position
			var random_initial_offset = Vector2(
				randf_range(-initial_dispersion_radius, initial_dispersion_radius),
				randf_range(-initial_dispersion_radius, initial_dispersion_radius)
			)
			stone_instance.global_position = global_position + random_initial_offset

			get_parent().add_child(stone_instance)
	else:
		print("No stones dropped (chance was %d%%)." % actual_drop_chance)
	# --- Akhir Modifikasi ---
