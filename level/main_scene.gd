extends Node3D

@export var animals : Array[PackedScene]
@export var animal_count = 8

func _ready() -> void:
	if animals:
		for i in animal_count:
			create_random_animal()

func create_random_animal():
	var new_animal = animals.pick_random().instantiate()
	
	# Give the animal the navigation region to help with moving around
	new_animal.nav_region = $NavigationRegion3D.get_region_rid()
	
	$Animals.add_child(new_animal)
	
	new_animal.global_position = Vector3(randf_range(-14, 14), 0, randf_range(-14, 14))
	
