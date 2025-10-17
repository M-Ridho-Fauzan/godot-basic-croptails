extends NodeState

@export var characters: NonPlaylableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
#@export var idle_state_time_interval: float = 5.0

@onready var idle_state_timer: Timer = Timer.new()

var idle_state_timeout: bool = false

func _ready() -> void:
	#idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if idle_state_timeout: 
		#transition.emit("Walk")
		# Cek probabilitas untuk mulai berjalan dari karakter NPC
		if randf() < characters.walk_initiate_chance:
			transition.emit("Walk")
		else:
			# Jika probabilitas tidak terpenuhi, NPC akan memilih untuk idle lagi
			# Reset flag dan restart timer dengan durasi idle baru yang acak
			idle_state_timeout = false
			idle_state_timer.wait_time = randf_range(characters.idle_duration_min, characters.idle_duration_max)
			idle_state_timer.start()


func _on_enter() -> void:
	# --- Tambahkan ini untuk debugging ---
	if characters == null:
		print("ERROR: 'characters' in idle_state is NULL! Please connect it in the editor for: ", get_tree().root.current_scene.name, "/", get_parent().get_parent().name, "/", get_parent().name, "/", name)
		return # Hentikan eksekusi untuk mencegah error lebih lanjut
	# --- Akhir debugging ---
	animated_sprite_2d.play("idle")
	
	idle_state_timeout = false
		# Set waktu tunggu timer secara dinamis berdasarkan properti karakter
	idle_state_timer.wait_time = randf_range(characters.idle_duration_min, characters.idle_duration_max)
	idle_state_timer.start()


func _on_exit() -> void:
	animated_sprite_2d.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	idle_state_timeout = true
