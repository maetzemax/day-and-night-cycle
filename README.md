# Day & Night Cycle (Godot plugin)

Lightweight day/night cycle system for Godot 4 with smooth transitions and configurable atmosphere.

## Features
- Smooth color transitions with gradient curves
- Sky cover textures with automatic blending
- Configurable sky darkening (horizon, ground)
- Ambient lighting control
- Separate day/night presets

## Preview

![Preview](images/preview.gif)

## Setup
1. Copy `addons/day_and_night_cycle` to your project
2. Enable plugin in Project Settings
3. Add `CycleController` to scene or use `res://addons/day_and_night_cycle/scenes/example.tscn`

## Configuration
**CycleData** (day/night presets):
- `colors`: Sky gradient over time
- `length`: Phase duration (seconds)  
- `light_energy`: Sun intensity curve
- `sky_cover`: Optional cloud/atmosphere texture
- `sky_darkening_curve`: Controls horizon/ground darkness

**CycleController** (main node):
- `day_data`/`night_data`: Assign preset resources
- `world_environment`: WorldEnvironment with ProceduralSkyMaterial
- `sun_light`: DirectionalLight3D for sun
- `ambient_light_color`/`sky_contribution`: Ambient lighting

## Troubleshooting
- Requires `ProceduralSkyMaterial` in WorldEnvironment
- Assign `sun_light` (DirectionalLight3D) to controller
- Check example scenes for proper setup