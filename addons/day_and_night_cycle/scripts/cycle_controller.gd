class_name CycleController
extends Node3D

signal day_started
signal night_started

#region Export
@export_group("Presets")
@export var day_data: CycleData
@export var night_data: CycleData

@export_group("General")
@export var world_environment: WorldEnvironment

@export_group("Lighting")
@export var sun_light: DirectionalLight3D
@export var ambient_light_color: Color
## Percentage of light used from the sky. If your sky is red and you set this value to 1.0
## there'll be a red ambient light in the world.
@export_range(0, 1, 0.01) var sky_contribution: float = 0.1

@export_group("Debug")
@export var show_debug_time: bool = false
#endregion

var _current_time: float = 0.0
var _cycle_time: float = 0.0
var _is_day: bool = true


func _ready():
	_cycle_time = day_data.length + night_data.length
	world_environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	world_environment.environment.ambient_light_color = ambient_light_color
	world_environment.environment.ambient_light_sky_contribution = sky_contribution


func _process(delta):
	_current_time += delta
	
	var previous_is_day = _is_day
	
	if _current_time < day_data.length:
		_is_day = true
	else:
		_is_day = false
	
	if previous_is_day != _is_day:
		if _is_day:
			day_started.emit()
		else:
			night_started.emit()
	
	if _current_time >= _cycle_time:
		_current_time = 0.0
		_is_day = true
		day_started.emit()
	
	var progress: float
	if _is_day:
		progress = _current_time / day_data.length
	else:
		progress = (_current_time - day_data.length) / night_data.length
	
	progress = clamp(progress, 0.0, 1.0)
	
	var day_light_energy = day_data.light_energy.sample(progress)
	var night_light_energy = night_data.light_energy.sample(progress)
	
	sun_light.light_energy = day_light_energy if _is_day else night_light_energy
	
	var sky_color: Color
	if _is_day:
		sky_color = day_data.colors.gradient.sample(progress)
	else:
		sky_color = night_data.colors.gradient.sample(progress)
	
	if world_environment.environment and world_environment.environment.sky:
		var sky_material = world_environment.environment.sky.sky_material
		if sky_material:
			sky_material.sky_top_color = sky_color
			# Apply curve-based color variations
			var current_data = day_data if _is_day else night_data
			
			sky_material.sky_horizon_color = sky_color.darkened(current_data.horizon_darkening_multiplier)
			sky_material.ground_horizon_color = sky_color.darkened(current_data.ground_horizon_darkening_multiplier)
			sky_material.ground_bottom_color = sky_color.darkened(current_data.ground_bottom_darkening_multiplier)
			
			if _is_day and day_data.sky_cover:
				sky_material.sky_cover = day_data.sky_cover
				var day_alpha = 1.0 - smoothstep(0.8, 1.0, progress)
				sky_material.sky_cover_modulate = Color(1, 1, 1, day_alpha)
			elif not _is_day and night_data.sky_cover:
				sky_material.sky_cover = night_data.sky_cover
				var night_alpha = 1.0 - abs(progress - 0.5) * 2.0
				night_alpha = smoothstep(0.0, 0.3, progress) * smoothstep(1.0, 0.7, progress)
				sky_material.sky_cover_modulate = Color(1, 1, 1, night_alpha)
	else:
		push_warning("Could not find sky material. Please assign WorldEnvironment accrodingly. Need Help? Look for 'Setup' in the README file.")
	
	var angle: float
	if _is_day:
		angle = progress * 180.0  # 0° → 180°
	else:
		angle = progress * 180.0 + 180.0  # 180° → 360°
	
	sun_light.rotation_degrees.x = -angle
	
	# Debug Info
	if show_debug_time:
		_print_debug_info()


## Formated time string (hh:mm:ss) since entering the tree.
func get_current_time_formatted() -> String:
	var hours = int(_current_time / 3600.0)
	var minutes = int(fmod(_current_time, 3600.0) / 60.0)
	var seconds = int(fmod(_current_time, 60.0))
	return "%02d:%02d:%02d" % [hours, minutes, seconds]


## Normalized progress [0.0, 1.0] of the whole cycle (day + night).
func get_cycle_progress() -> float:
	return (_current_time / _cycle_time)


## Normalized progress [0.0, 1.0] of current phase (day OR night).
func get_phase_progress() -> float:
	if _is_day:
		return _current_time / day_data.length
	else:
		return (_current_time - day_data.length) / night_data.length


## Jump to any state of the cycle. Progress Value from 0.0 (Start) to 1.0 (End) of the cylces progress.
func set_cycle_progress(progress: float):
	_current_time = progress * _cycle_time
	_current_time = clamp(_current_time, 0.0, _cycle_time)


## Jump to begin of the day.
func skip_to_day():
	_current_time = 0.0
	_is_day = true
	day_started.emit()


## Jump to begin of the night.
func skip_to_night():
	_current_time = day_data.length
	_is_day = false
	night_started.emit()


func _print_debug_info():
	var cycle_progress = get_cycle_progress() * 100
	var phase = "Day" if _is_day else "Night"
	var phase_progress = get_phase_progress() * 100
	
	print("Time: %s | Cycle: %.1f%% | Phase: %s (%.1f%%)" % [
		get_current_time_formatted(),
		cycle_progress,
		phase,
		phase_progress,
	])
