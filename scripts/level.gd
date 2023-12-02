extends TileMap

const WALL_TERRAIN_ID: int = 0
const WALKABLE_TERRAIN_ID: int = 3
const TILE_LAYER: int = 0
const NAV_LAYER: int = 1
const WATER_LAYER : int = 2

func _ready():
	var air_cells: Array[Vector2i] = []
	for cell_coords in get_used_cells(TILE_LAYER):
		var data: TileData = get_cell_tile_data(TILE_LAYER, cell_coords)
		if data.terrain != WALL_TERRAIN_ID:
			air_cells.append(cell_coords)
	set_cells_terrain_connect(NAV_LAYER, air_cells, 0, WALKABLE_TERRAIN_ID)

