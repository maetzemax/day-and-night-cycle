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
