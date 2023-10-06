extends Control

@onready var heart_ui_full = $HeartUIFull
@onready var heart_ui_empty = $HeartUIEmpty

var max_hearts = 4:
	get:
		return max_hearts
	set(value):
		max_hearts = max(value, 1)
		self.hearts = min(hearts, max_hearts)
		if heart_ui_empty != null:
			heart_ui_empty.size.x = max_hearts * 15

var hearts = 4:
	get:
		return hearts
	set(value):
		hearts = clamp(value, 0, max_hearts)
		if heart_ui_full != null:
			heart_ui_full.size.x = hearts * 15

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty != null:
		heart_ui_empty.size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts)
	PlayerStats.max_health_changed.connect(set_max_hearts)
