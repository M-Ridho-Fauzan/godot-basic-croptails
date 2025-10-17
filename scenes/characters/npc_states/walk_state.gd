extends NodeState

@export var characters: NonPlaylableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var speed: float

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
	
	call_deferred("character_setup") # ini untuk memanggil func yang di dev, setelah frame ini selesai pemerosesan sehingga pangilan di tangguhkan akan memanggil pengaturan karakter selama waktu idle

func character_setup() -> void:
	await get_tree().physics_frame
	
	# === PERBAIKAN DI SINI: Tambahkan penundaan acak untuk target awal ===
	# Ini akan memastikan setiap NPC menentukan target awalnya pada waktu yang sedikit berbeda
	# sehingga mereka cenderung mendapatkan titik yang berbeda.
	var initial_delay = randf_range(0.0, 0.5) # Penundaan antara 0 dan 0.5 detik
	await get_tree().create_timer(initial_delay).timeout
	# ======================================================================
	
	set_movement_target()

func set_movement_target() -> void:
	var target_postion: Vector2 = NavigationServer2D.map_get_random_point(
		navigation_agent_2d.get_navigation_map(),
		navigation_agent_2d.navigation_layers,
		false
	)
	navigation_agent_2d.target_position = target_postion
	speed = randf_range(min_speed, max_speed)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		characters.current_walk_cycle += 1
		set_movement_target()
		return
	
	# new Code
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var desired_direction: Vector2 = characters.global_position.direction_to(next_path_position)
	
	# Selalu berikan kecepatan yang diinginkan ke NavigationAgent2D
	# Ia akan menghitung kecepatan aman jika avoidance aktif, atau meneruskan jika tidak.
	navigation_agent_2d.velocity = desired_direction * speed
	# end New Code
	
	#var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	#var target_direction: Vector2 = characters.global_position.direction_to(target_position)
	#
	#var velocity: Vector2 = target_direction * speed
	#
	#if navigation_agent_2d.avoidance_enabled: 
		#animated_sprite_2d.flip_h = target_direction.x < 0
		#navigation_agent_2d.velocity = velocity
	#else:
		#characters.velocity = target_direction * speed
		#characters.move_and_slide()

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	characters.velocity = safe_velocity
	characters.move_and_slide()

func _on_next_transitions() -> void:
	if characters.current_walk_cycle == characters.walk_cycles:
		characters.velocity = Vector2.ZERO
		transition.emit("idle")


func _on_enter() -> void:
	animated_sprite_2d.play("walk")
	characters.current_walk_cycle = 0


func _on_exit() -> void:
	animated_sprite_2d.stop()
