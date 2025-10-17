class_name GrowtCycleComponent
extends Node

@export var current_growt_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var starting_day: int
var current_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
	
		growt_states(starting_day, day)
		harvest_state(starting_day, day)

func growt_states(starting_day: int, current_day: int) -> void:
	if current_growt_state == DataTypes.GrowthStates.Maturity:
		return
	
	var num_states = 5
	
	var growt_days_passed = (current_day - starting_day) % num_states
	var state_index = growt_days_passed % num_states + 1
	
	current_growt_state = state_index
	
	var name = DataTypes.GrowthStates.keys()[current_growt_state]
	print("Current growt state: ", name, " State Index: ", state_index)
	
	if current_growt_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()

func harvest_state(starting_day: int, current_day: int) -> void:
	if current_growt_state == DataTypes.GrowthStates.Harvesting:
		return
	
	var days_passed = (current_day - starting_day) % days_until_harvest
	
	if days_passed == days_until_harvest - 1:
		current_growt_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growt_state
