extends TileMapLayer

var minePower: float = 5.0

var mineCooldown: float = 0.1
var mineCooldownTimer: float = 0.1
@onready var label: Label = %Label

var ores: Dictionary = {
	Vector2i(0,0): [50,"dirt"],
	Vector2i(1,0): [200,"stone"],
	Vector2i(2,0): [100000,"barrier"],
	Vector2i(3,0): [500,"coal"],
	Vector2i(4,0): [800,"iron"]
}

var minedTilesHealth: Dictionary = {}

var inventory: Dictionary = {
	"dirt" : 0,
	"stone" : 0,
	"coal" : 0,
	"iron" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mineCooldownTimer -= delta
	if Input.is_action_pressed("click") and mineCooldownTimer < 0:
		mine()
	print(inventory)
		

func mine():
	
	var tileSelected = local_to_map(get_local_mouse_position()) # the location of the tile
	var tileSelectedAtlas = get_cell_atlas_coords(tileSelected) # the texture of the tile
	
	if tileSelectedAtlas != Vector2i(-1,-1): # if the tile is not empty:
		
		mineCooldownTimer = mineCooldown
		
		if not minedTilesHealth.has(tileSelected):
			minedTilesHealth[tileSelected] = (ores[tileSelectedAtlas])[0] - minePower
			
		minedTilesHealth[tileSelected] -= minePower
		
		if minedTilesHealth[tileSelected] <= 0:
			erase_cell(tileSelected)
			inventory[(ores[tileSelectedAtlas])[1]] += 1
			label.text = "Dirt: %s\nStone: %s\nCoal: %s\nIron: %s\n" % [
				inventory["dirt"],
				inventory["stone"],
				inventory["coal"],
				inventory["iron"]
			]
