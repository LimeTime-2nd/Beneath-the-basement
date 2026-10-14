extends TileMapLayer

var minePower: float = 5.0

var mineCooldown: float = 0.1
var mineCooldownTimer: float = 0.1

var healthForRockType: Dictionary = {
    Vector2i(0,0): 50, # dirt
    Vector2i(1,0): 200  # stone
}

var minedTilesHealth: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    mineCooldownTimer -= delta
    if Input.is_action_pressed("click") and mineCooldownTimer < 0:
        mine()
        

func mine():
    
    var tileSelected = local_to_map(get_local_mouse_position()) # the location of the tile
    var tileSelectedAtlas = get_cell_atlas_coords(tileSelected) # the texture of the tile
    
    if tileSelectedAtlas != Vector2i(-1,-1): # if the tile is not empty:
        
        mineCooldownTimer = mineCooldown
        
        if not minedTilesHealth.has(tileSelected):
            minedTilesHealth[tileSelected] = healthForRockType[tileSelectedAtlas] - minePower
            
        minedTilesHealth[tileSelected] -= minePower
        
        if minedTilesHealth[tileSelected] <= 0:
            erase_cell(tileSelected)	
