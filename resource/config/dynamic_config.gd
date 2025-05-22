class_name DynamicConfig
extends Resource


## Dynamic change interval (s)
@export var dynamic_interval: Array[float]

## Configure dynamically changing values. The size must be same as [dynamic_interval].
@export var dynamic_change_value: Array[Config]
