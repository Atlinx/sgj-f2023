extends TextureButton

var cool_down_count_down
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("hero")
var cool_down_time
@export var texture_progress : TextureProgressBar


func _ready():
	player.sword_cd.connect(_on_sword_cd)
	texture_progress.value = 0
	texture_progress.texture_progress = texture_normal
	
	
func _process(delta):
	if cool_down_count_down != null:
		if cool_down_count_down > 0:
			cool_down_count_down -= delta
			texture_progress.value = (cool_down_count_down / cool_down_time)*100

	
func _on_sword_cd(cd:float):
	cool_down_time = cd
	cool_down_count_down = cd

