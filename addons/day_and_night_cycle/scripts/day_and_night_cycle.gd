extends Node3D
class_name DayAndNightCycle

#region Export
@export_group("Presets")
@export var day_data: CycleData
@export var night_data: CycleData

@export_group("General")
@export var sun_light: DirectionalLight3D
@export var world_environment: WorldEnvironment

@export_group("Debug")
@export var show_debug_time: bool = false
#endregion

var current_time: float = 0.0
var cycle_time: float = 0.0
var is_day: bool = true

signal day_started
signal night_started

func _ready():
	cycle_time = day_data.length + night_data.length

func _process(delta):
	current_time += delta
	
	var previous_is_day = is_day
	
	if current_time < day_data.length:
		is_day = true
	else:
		is_day = false
	
	if previous_is_day != is_day:
		if is_day:
			day_started.emit()
		else:
			night_started.emit()
	
	if current_time >= cycle_time:
		current_time = 0.0
		is_day = true
		day_started.emit()
	
	var progress: float
	if is_day:
		progress = current_time / day_data.length
	else:
		progress = (current_time - day_data.length) / night_data.length
	
	progress = clamp(progress, 0.0, 1.0)
	
	var day_light_energy = day_data.light_energy.sample(progress)
	var night_light_energy = night_data.light_energy.sample(progress)	
	
	sun_light.light_energy = day_light_energy if is_day else night_light_energy
	
	var sky_color: Color
	if is_day:
		sky_color = day_data.colors.gradient.sample(progress)
	else:
		sky_color = night_data.colors.gradient.sample(progress)
	
	if world_environment.environment and world_environment.environment.sky:
		var sky_material = world_environment.environment.sky.sky_material
		if sky_material:
			sky_material.sky_top_color = sky_color
			sky_material.sky_horizon_color = sky_color
			sky_material.ground_bottom_color = sky_color
			sky_material.ground_horizon_color = sky_color
	else:
		push_warning("Could not find sky material. Please assign WorldEnvironment accrodingly. Need Help? Look for 'Setup' in the README file.")
	
	var angle: float
	if is_day:
		angle = progress * 180.0  # 0° → 180°
	else:
		angle = progress * 180.0 + 180.0  # 180° → 360°
	
	sun_light.rotation_degrees.x = -angle
	
	# Debug Info
	if show_debug_time:
		_print_debug_info()

func get_current_time_formatted() -> String:
	var hours = int(current_time / 3600.0)
	var minutes = int(fmod(current_time, 3600.0) / 60.0)
	var seconds = int(fmod(current_time, 60.0))
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func get_day_progress() -> float:
	if is_day:
		return current_time / day_data.length
	else:
		return (current_time - day_data.length) / night_data.length

## 0.0 = Start of the day; 1.0 = End of cycle
func set_time_of_day(progress: float):
	current_time = progress * cycle_time
	current_time = clamp(current_time, 0.0, cycle_time)

## Jump to begin of the day
func skip_to_day():
	current_time = 0.0
	is_day = true
	day_started.emit()

## Jump to begin of the night
func skip_to_night():
	current_time = day_data.length
	is_day = false
	night_started.emit()

func _print_debug_info():
	var cycle_progress = (current_time / cycle_time) * 100
	var phase = "Day" if is_day else "Night"
	var phase_progress = get_day_progress() * 100
	
	print("Time: %s | Cycle: %.1f%% | Phase: %s (%.1f%%)" % [
		get_current_time_formatted(),
		cycle_progress,
		phase,
		phase_progress
	])
