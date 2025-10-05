# Day & Night Cycle (Godot plugin)

Adds an easy-to-use, customizable day & night cycle for Godot 4 projects.

## Features
- Smooth day/night transitions using gradients and curves
- Separate presets for day and night phases
- Controls DirectionalLight3D and WorldEnvironment
- Signals for phase changes (day_started, night_started)

## Preview

![Preview](images/preview.gif)

## Essentials
- Install: copy `addons/day_and_night_cycle` into your project's `addons/` folder and enable the plugin in Project Settings -> Plugins.
- Quick start: instance `res://addons/day_and_night_cycle/scenes/example.tscn` or add a `CycleController` node and set `day_data`, `night_data`, `sun_light`, and `world_environment` in the inspector.

## Configuration (short)
- `CycleData` (resource): `colors` (GradientTexture2D), `length` (seconds), `light_energy` (Curve).
- `CycleController` (node): assign `day_data`, `night_data`, `world_environment` (WorldEnvironment with a ProceduralSkyMaterial) and `sun_light` (DirectionalLight3D).

## Example & presets
- Example scene: `addons/day_and_night_cycle/scenes/example.tscn`.
- Presets: `addons/day_and_night_cycle/presets/default_day_cycle.tres`, `addons/day_and_night_cycle/presets/default_night_cycle.tres`.

## Troubleshooting
- If sky colors don't update, ensure the `WorldEnvironment.environment.sky.sky_material` is a `ProceduralSkyMaterial`.
- Make sure `sun_light` (DirectionalLight3D) is assigned to the controller.