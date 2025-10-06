extends Resource

class_name CycleData

## Represent the colors on the sky during the day cycle.
## Colors aligned on the left are the morning-light.
## Colors on the right are the end-of-day light.
@export var colors: GradientTexture2D

## Length of the day in seconds.
@export var length: float

## Control the sun lights enegry during the day.
@export var light_energy: Curve

## Image layer abover the sky color
@export var sky_cover: Texture2D

@export_group("Sky Color Variations")
## Multiplier for horizon darkening
@export var horizon_darkening_multiplier: float = 0.1
## Multiplier for ground horizon darkening
@export var ground_horizon_darkening_multiplier: float = 0.2
## Multiplier for ground bottom darkening
@export var ground_bottom_darkening_multiplier: float = 0.4
