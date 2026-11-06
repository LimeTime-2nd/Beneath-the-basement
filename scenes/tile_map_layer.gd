extends TileMapLayer

var minePower: float = 5.0

var mineCooldown: float = 0.1
var mineCooldownTimer: float = 0.1

var mineEfficiency: float = 1.0

@onready var label: Label = %Label
@onready var black: TileMapLayer = %Black
@onready var ray_cast_2d: RayCast2D = %RayCast2D

var blocks: Dictionary = {
	#Vector2i(1,0): [40,"stone"],
	#Vector2i(2,0): [100000,"barrier"],
	#Vector2i(3,0): [120,"coal"],
	#Vector2i(4,0): [200,"iron"]
	0: {
		"name": "dirtBlock",
		"composition": ["dirt"],
		"health": 10.0,
		"max": [5.0]
	},
	1: {
		"name": "sandstoneBlock",
		"composition": ["sandstone"],
		"health": 40.0,
		"max": [5.0]
	},
	2: {
		"name": "sandstoneBlockLCoal",
		"composition": ["sandstone","coal"],
		"health": 40.0,
		"max": [4.0,1.0]
	},
	3: {
		"name": "sandstoneBlockHCoal",
		"composition": ["sandstone","coal"],
		"health": 40.0,
		"max": [2.0,3.0]
	},
	4: {
		"name": "shaleBlock",
		"composition": ["shale"],
		"health": 15.0,
		"max": [5.0]
	},
	5: {
		"name": "limestoneBlock",
		"composition": ["limestone"],
		"health": 25.0,
		"max": [5.0]
	},
	6: {
		"name": "limestoneBlockLCoal",
		"composition": ["limestone","coal"],
		"health": 25.0,
		"max": [4.0,1.0]
	},
	7: {
		"name": "limestoneBlockHCoal",
		"composition": ["limestone","coal"],
		"health": 25.0,
		"max": [2.0,3.0]
	},
	8: {
		"name": "basaltBlock",
		"composition": ["basalt"],
		"health": 70.0,
		"max": [5.0]
	},
	9: {
		"name": "basaltBlockLCoal",
		"composition": ["basalt","coal"],
		"health": 75.0,
		"max": [4.0,1.0]
	},
	10: {
		"name": "basaltBlockLIron",
		"composition": ["basalt","iron"],
		"health": 80.0,
		"max": [4.0,1.0]
	},
	11: {
		"name": "basaltBlockHIron",
		"composition": ["basalt","iron"],
		"health": 85.0,
		"max": [2.0,3.0]
	},
	12: {
		"name": "slateBlock",
		"composition": ["slate"],
		"health": 40.0,
		"max": [5.0]
	},
	13: {
		"name": "slateBlockLIron",
		"composition": ["slate","iron"],
		"health": 45.0,
		"max": [4.0,1.0]
	},
	14: {
		"name": "slateBlockHIron",
		"composition": ["slate","iron"],
		"health": 50.0,
		"max": [2.0,3.0]
	},
	15: {
		"name": "slateBlockLGold",
		"composition": ["slate","gold"],
		"health": 45.0,
		"max": [4.0,1.0]
	},
	16: {
		"name": "slateBlockHGold",
		"composition": ["slate","Gold"],
		"health": 50.0,
		"max": [2.0,3.0]
	},
	17: {
		"name": "graniteBlock",
		"composition": ["granite"],
		"health": 55.0,
		"max": [5.0]
	},
	19: {
		"name": "barrier"
	}
}

var minedTilesHealth: Dictionary = {}

var inventory: Dictionary = {
	"dirt" : 0,
	"stone" : 0,
	"coal" : 0,
	"iron" : 0,
	"gold" : 0,
	"sandstone" : 0,
	"limestone" : 0,
	"shale" : 0,
	"basalt" : 0,
	"slate" : 0,
	"granite" : 0
}

func _process(delta: float) -> void:
	mineCooldownTimer -= delta
	if Input.is_action_pressed("click") and mineCooldownTimer < 0:
		mine()

func mine():
	
	var blockSelected = local_to_map(get_local_mouse_position()) # the location of the block
	var blockSelectedAtlas = get_cell_atlas_coords(blockSelected) # the texture of the block
	
	if blockSelectedAtlas == Vector2i(-1,-1):# or not (blockSelected.x == floor(ray_cast_2d.collision_point/8).x and blockSelected.y == floor(ray_cast_2d.collision_point/8).y):
		return
	
	var blockOreData = blocks[blockSelectedAtlas.x]
	
	if not blockOreData.has("health"):
		return
	
	mineCooldownTimer = mineCooldown # reset the cooldown
	
	if not minedTilesHealth.has(blockSelected):
		# if the tile about to be mined is at full health, create a variable for it
		# composition = [0] / health = [1] / max = [2] 
		minedTilesHealth[blockSelected] = [blockOreData["composition"],blockOreData["health"],blockOreData["max"]]
	
	(minedTilesHealth[blockSelected])[1] -= minePower # reduce the health of tile
	
	for ores in range((minedTilesHealth[blockSelected])[0].size()):
		# for all the ores in a block's composition, gain a specific amount of those ores in the player's inventory
		inventory[(blockOreData["composition"])[ores]] += (minePower / blockOreData["health"] * (blockOreData["max"])[ores])
	
	#inventory[blockOreData["name"]] += (minePower / blockOreData["health"] * blockOreData["max"])
	
	label.text = "Dirt: %s\nStone: %s\nCoal: %s\nIron: %s\n" % [
			inventory["dirt"],
			inventory["stone"],
			inventory["coal"],
			inventory["iron"]
		]
	
	
	set_cell(blockSelected, 0, Vector2i(blockSelectedAtlas.x,floor((blockOreData["health"]-(minedTilesHealth[blockSelected])[1])/blockOreData["health"]*6)))
	
	if (minedTilesHealth[blockSelected])[1] <= 0.0:
		erase_cell(blockSelected)
		black.erase_cell(blockSelected)
		black.erase_cell(blockSelected + Vector2i(0,1))
		black.erase_cell(blockSelected + Vector2i(1,1))
		black.erase_cell(blockSelected + Vector2i(1,0))
		black.erase_cell(blockSelected + Vector2i(1,-1))
		black.erase_cell(blockSelected + Vector2i(0,-1))
		black.erase_cell(blockSelected + Vector2i(-1,-1))
		black.erase_cell(blockSelected + Vector2i(-1,0))
		black.erase_cell(blockSelected + Vector2i(-1,1))
