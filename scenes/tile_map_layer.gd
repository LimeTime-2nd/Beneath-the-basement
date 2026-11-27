extends TileMapLayer

var minePower: float = 500.0

#5.0 minepwr
#0.1 cooldown
var mineCooldown: float = 0.0
var mineCooldownTimer: float = 0.1

var mineEfficiency: float = 1.0

@onready var breaking: TileMapLayer = %Breaking
@onready var label: Label = %Label
@onready var black: TileMapLayer = %Black
@onready var ray_cast_2d: RayCast2D = %RayCast2D

var general_block_stats: Dictionary = {
	"max": [5.0],
	"light": [4.0,1.0],
	"heavy": [3.0,2.0],
	"dirtHP": 10.0,
	"clayHP": 20.0,
	"sandstoneHP": 50.0,
	"shaleHP": 25.0,
	"limestoneHP": 40.0,
	"basaltHP": 110.0,
	"graniteHP": 90.0
}

var blocks: Dictionary = {
	#Vector2i(1,0): [40,"stone"],
	#Vector2i(2,0): [100000,"barrier"],
	#Vector2i(3,0): [120,"coal"],
	#Vector2i(4,0): [200,"iron"]
	Vector2i(0,0): {
		"name": "dirtBlock",
		"composition": ["dirt"],
		"health": general_block_stats["dirtHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(8,0): {
		"name": "barrier",
	},
	Vector2i(0,1): {
		"name": "clayBlock",
		"composition": ["clay"],
		"health": general_block_stats["clayHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(1,1): {
		"name": "clayBlockLCopper",
		"composition": ["clay","copper"],
		"health": general_block_stats["clayHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(0,2): {
		"name": "sandstoneBlock",
		"composition": ["sandstone"],
		"health": general_block_stats["sandstoneHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(1,2): {
		"name": "sandstoneBlockLCopper",
		"composition": ["sandstone","copper"],
		"health": general_block_stats["sandstoneHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(2,2): {
		"name": "sandstoneBlockHCopper",
		"composition": ["sandstone","copper"],
		"health": general_block_stats["sandstoneHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(3,2): {
		"name": "sandstoneBlockLTin",
		"composition": ["sandstone","tin"],
		"health": general_block_stats["sandstoneHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(4,2): {
		"name": "sandstoneBlockLCoal",
		"composition": ["sandstone","coal"],
		"health": general_block_stats["sandstoneHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(5,2): {
		"name": "sandstoneBlockHCoal",
		"composition": ["sandstone","coal"],
		"health": general_block_stats["sandstoneHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(0,3): {
		"name": "shaleBlock",
		"composition": ["shale"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(1,3): {
		"name": "shaleBlockLCopper",
		"composition": ["shale","copper"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(2,3): {
		"name": "shaleBlockLCoal",
		"composition": ["shale","coal"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(3,3): {
		"name": "shaleBlockHCoal",
		"composition": ["shale","coal"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(4,3): {
		"name": "shaleBlockLZinc",
		"composition": ["shale","zinc"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(5,3): {
		"name": "shaleBlockHZinc",
		"composition": ["shale","zinc"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(6,3): {
		"name": "shaleBlockLSilver",
		"composition": ["shale","silver"],
		"health": general_block_stats["shaleHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(0,4): {
		"name": "limestoneBlock",
		"composition": ["limestone"],
		"health": general_block_stats["limestoneHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(1,4): {
		"name": "limestoneBlockLCopper",
		"composition": ["limestone","copper"],
		"health": general_block_stats["limestoneHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(2,4): {
		"name": "limestoneBlockHCopper",
		"composition": ["limestone","copper"],
		"health": general_block_stats["limestoneHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(3,4): {
		"name": "limestoneBlockLZinc",
		"composition": ["limestone","zinc"],
		"health": general_block_stats["limestoneHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(4,4): {
		"name": "limestoneBlockHZinc",
		"composition": ["limestone","zinc"],
		"health": general_block_stats["limestoneHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(5,4): {
		"name": "limestoneBlockLSilver",
		"composition": ["limestone","silver"],
		"health": general_block_stats["limestoneHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(0,5): {
		"name": "basaltBlock",
		"composition": ["basalt"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(1,5): {
		"name": "basaltBlockLCopper",
		"composition": ["basalt","copper"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(2,5): {
		"name": "basaltBlockHCopper",
		"composition": ["basalt","copper"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(3,5): {
		"name": "basaltBlockLIron",
		"composition": ["basalt","iron"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(4,5): {
		"name": "basaltBlockHIron",
		"composition": ["basalt","iron"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(5,5): {
		"name": "basaltBlockLZinc",
		"composition": ["basalt","zinc"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(6,5): {
		"name": "basaltBlockLTitanium",
		"composition": ["basalt","titanium"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(7,5): {
		"name": "basaltBlockLSilver",
		"composition": ["basalt","silver"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(8,5): {
		"name": "basaltBlockHSilver",
		"composition": ["basalt","silver"],
		"health": general_block_stats["basaltHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(0,6): {
		"name": "graniteBlock",
		"composition": ["granite"],
		"health": general_block_stats["graniteHP"],
		"max": general_block_stats["max"]
	},
	Vector2i(1,6): {
		"name": "graniteBlockLTin",
		"composition": ["granite","tin"],
		"health": general_block_stats["graniteHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(2,6): {
		"name": "graniteBlockHTin",
		"composition": ["granite","tin"],
		"health": general_block_stats["graniteHP"],
		"max": general_block_stats["heavy"]
	},
	Vector2i(3,6): {
		"name": "graniteBlockLIron",
		"composition": ["granite","iron"],
		"health": general_block_stats["graniteHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(4,6): {
		"name": "graniteBlockLSilver",
		"composition": ["granite","silver"],
		"health": general_block_stats["graniteHP"],
		"max": general_block_stats["light"]
	},
	Vector2i(5,6): {
		"name": "graniteBlockHSilver",
		"composition": ["granite","silver"],
		"health": general_block_stats["graniteHP"],
		"max": general_block_stats["heavy"]
	},
}
var minedTilesHealth: Dictionary = {}

var inventory: Dictionary = {
	"dirt" : 0,
	"coal" : 0,
	"iron" : 0,
	"gold" : 0,
	"zinc" : 0,
	"silver" : 0,
	"titanium" : 0,
	"tin" : 0,
	"copper" : 0,
	"clay" : 0,
	"sandstone" : 0,
	"limestone" : 0,
	"shale" : 0,
	"basalt" : 0,
	"granite" : 0,
	"slate" : 0,
	"gneiss" : 0
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
	
	var blockOreData = blocks[blockSelectedAtlas]
	
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
	
	label.text = str(inventory)
	
	breaking.set_cell(blockSelected, 1, Vector2i(0,floor((blockOreData["health"]-(minedTilesHealth[blockSelected])[1])/blockOreData["health"]*6)))
	
	if (minedTilesHealth[blockSelected])[1] <= 0.0:
		erase_cell(blockSelected)
		breaking.erase_cell(blockSelected)
		minedTilesHealth.erase(blockSelected)
		print(minedTilesHealth)
		
		black.erase_cell(blockSelected)
		black.erase_cell(blockSelected + Vector2i(0,1))
		black.erase_cell(blockSelected + Vector2i(1,1))
		black.erase_cell(blockSelected + Vector2i(1,0))
		black.erase_cell(blockSelected + Vector2i(1,-1))
		black.erase_cell(blockSelected + Vector2i(0,-1))
		black.erase_cell(blockSelected + Vector2i(-1,-1))
		black.erase_cell(blockSelected + Vector2i(-1,0))
		black.erase_cell(blockSelected + Vector2i(-1,1))
