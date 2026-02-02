/datum/island_feature_template
	var/name = "Generic Feature"
	var/datum/map_template/template_path
	var/width = 5 // Template width
	var/height = 5 // Template height
	var/min_distance_from_water = 5 // Minimum tiles from water edge
	var/max_distance_from_water = 999 // Maximum tiles from water edge
	var/allow_on_beach = FALSE // Can spawn on beach tiles
	var/min_elevation = 0 // Minimum elevation level
	var/max_elevation = 999 // Maximum elevation level
	var/require_flat_terrain = TRUE // Requires all tiles to be same height
	var/spawn_weight = 100 // Weight for random selection
	var/max_height_variance = 0 // Maximum height difference allowed within template area
	var/z_offset = 0
