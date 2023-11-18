extends Node


@export var health: Health
@export var sprites: Array[Sprite2D]
@export var flash_curve: Curve
@export var flash_duration: float = 0.2

var _flash_timer: float = 0


func _ready():
	var shared_material: Material
	for sprite in sprites:
		if sprite.material != null:	
			shared_material = sprite.material
	shared_material = shared_material.duplicate()
	for sprite in sprites:
		sprite.material = shared_material
	
	health.damaged.connect(_on_damaged)


func _on_damaged(amount: int):
	_flash_timer = flash_duration


func _process(delta):
	var flash_amount: float
	if _flash_timer > 0:
		_flash_timer -= delta
		if _flash_timer > 0:
			flash_amount = _flash_timer / flash_duration 
	
	for sprite in sprites:
		sprite.material.set_shader_parameter("flash_amount", flash_amount)
