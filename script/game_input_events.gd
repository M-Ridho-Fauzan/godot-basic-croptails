class_name GameInputEvents

static var direction: Vector2

static func movement_input() -> Vector2: 
	var input_vector = Vector2.ZERO # Inisialisasi vektor input untuk frame ini
	
	# Akumulasikan semua input yang ditekan
	if Input.is_action_pressed("walk_right"): 
		input_vector.x += 1
	if Input.is_action_pressed("walk_left"): 
		input_vector.x -= 1
	if Input.is_action_pressed("walk_down"): 
		input_vector.y += 1
	if Input.is_action_pressed("walk_up"): 
		input_vector.y -= 1
		
	# Normalisasi vektor untuk mencegah pergerakan diagonal yang lebih cepat
	return input_vector.normalized()

# Ini adalah masukan (switch) gerakan
static func is_movement_input() -> bool:
	return Input.is_action_pressed("walk_left") or \
		   Input.is_action_pressed("walk_right") or \
		   Input.is_action_pressed("walk_up") or \
		   Input.is_action_pressed("walk_down")

static func use_tool() -> bool: 
	var use_tool_value: bool = Input.is_action_just_pressed("hit")
	
	return use_tool_value
