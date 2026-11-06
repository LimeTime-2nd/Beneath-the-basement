extends Node

@export var coal_noise_node: NoiseTexture2D
@export var iron_noise_node: NoiseTexture2D
@export var layer0to1_noise_node: NoiseTexture2D
@export var layer1_noise_node: NoiseTexture2D
@export var layer1to2_noise_node: NoiseTexture2D
@export var layer2_noise_node: NoiseTexture2D

@onready var terrain: TileMapLayer = %Terrain
@onready var black: TileMapLayer = %Black

var coalNoise: Noise
var ironNoise: Noise
var layer0to1Noise: Noise
var layer1Noise: Noise
var layer1to2Noise: Noise
var layer2Noise: Noise

# around -0.15 to -0.9
var source_id: int = 0

var atlas: Dictionary = {
	"dirtBlock" = Vector2i(0,0),
	"sandstoneBlock" = Vector2i(1,0),
	"sandstoneBlockLCoal" = Vector2i(2,0),
	"sandstoneBlockHCoal" = Vector2i(3,0),
	"shaleBlock" = Vector2i(4,0),
	"limestoneBlock" = Vector2i(5,0),
	"limestoneBlockLCoal" = Vector2i(6,0),
	"limestoneBlockHCoal" = Vector2i(7,0),
	"basaltBlock" = Vector2i(8,0),
	"basaltBlockLCoal" = Vector2i(9,0),
	"basaltBlockLIron" = Vector2i(10,0),
	"basaltBlockHIron" = Vector2i(11,0),
	"slateBlock" = Vector2i(12,0),
	"slateBlockLIron" = Vector2i(13,0),
	"slateBlockHIron" = Vector2i(14,0),
	"slateBlockLGold" = Vector2i(15,0),
	"slateBlockHGold" = Vector2i(16,0),
	"graniteBlock" = Vector2i(17,0),
}

func _ready() -> void:
	
	var test: Array
	coalNoise = coal_noise_node.noise
	coalNoise.seed = randi_range(0,1000)
	ironNoise = iron_noise_node.noise
	ironNoise.seed = randi_range(0,1000)
	layer0to1Noise = layer0to1_noise_node.noise
	layer0to1Noise.seed = randi_range(0,1000)
	layer1Noise = layer1_noise_node.noise
	layer1Noise.seed = randi_range(0,1000)
	layer1to2Noise = layer1to2_noise_node.noise
	layer1to2Noise.seed = randi_range(0,1000)
	layer2Noise = layer2_noise_node.noise
	layer2Noise.seed = randi_range(0,1000)

	create_layer(0,"layer0to1")
	create_layer(1,"layer1")
	create_layer(2,"layer1to2")
	create_layer(3,"layer2")
	create_layer(4,"layer2")
	
	#var noise_value: float
	#for x in range(-100,101):
		#for y in range(22,101):
			#noise_value = layer2Noise.get_noise_2d(x,y)
			#test.append(noise_value)
	#print(test.max())
	#print(test.min())

func create_chunk(coordx: int, coordy: int, type: String):
	
	var noise_value: float
	var offset = Vector2i(coordx,coordy) * 16
	
	if type == "layer0to1":
		for x in range(16):
			for y in range(16):
				noise_value = layer0to1Noise.get_noise_2d(x+offset.x,y+offset.y)
				if noise_value > (-0.15 - y / 21.0):
					layer1_gen(Vector2i(x,y)+offset)
				else:
					terrain.set_cell(Vector2i(x,y)+offset,source_id,atlas["dirtBlock"])
	if type == "layer1":
		for x in range(16):
			for y in range(16):
				layer1_gen(Vector2i(x,y)+offset)
	if type == "layer1to2":
		for x in range(16):
			for y in range(16):
				noise_value = layer1to2Noise.get_noise_2d(x+offset.x,y+offset.y)
				if noise_value > (-0.15 - y / 21.0):
					layer2_gen(Vector2i(x,y)+offset)
				else:
					layer1_gen(Vector2i(x,y)+offset)
	if type == "layer2":
		for x in range(16):
			for y in range(16):
				layer2_gen(Vector2i(x,y)+offset)

func create_layer(coordy: int, type: String):
	for x in range(-5,5):
		create_chunk(x,coordy,type)
		
func layer1_gen(blockPosition: Vector2i):
	var noise_value = layer1Noise.get_noise_2d(blockPosition.x,blockPosition.y)
	if noise_value > -0.45:
		noise_value = coalNoise.get_noise_2d(blockPosition.x,blockPosition.y)
		if noise_value > -0.35:
			terrain.set_cell(blockPosition,source_id,atlas["limestoneBlockHCoal"])
		elif noise_value > -0.4:
			terrain.set_cell(blockPosition,source_id,atlas["limestoneBlockLCoal"])
		else:
			terrain.set_cell(blockPosition,source_id,atlas["limestoneBlock"])
	elif noise_value > -0.6:
		terrain.set_cell(blockPosition,source_id,atlas["shaleBlock"])
	else:
		noise_value = coalNoise.get_noise_2d(blockPosition.x,blockPosition.y)
		if noise_value > -0.35:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneBlockHCoal"])
		elif noise_value > -0.4:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneBlockLCoal"])
		else:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneBlock"])
			
func layer2_gen(blockPosition: Vector2i):
	var noise_value = layer2Noise.get_noise_2d(blockPosition.x,blockPosition.y)
	if noise_value < 0.3:
		noise_value = coalNoise.get_noise_2d(blockPosition.x,blockPosition.y)
		if noise_value > -0.32:
			terrain.set_cell(blockPosition,source_id,atlas["basaltBlockLCoal"])
		else:
			terrain.set_cell(blockPosition,source_id,atlas["basaltBlock"])
		noise_value = ironNoise.get_noise_2d(blockPosition.x,blockPosition.y)
		if noise_value > -0.3:
			terrain.set_cell(blockPosition,source_id,atlas["basaltBlockHIron"])
		elif noise_value > -0.35:
			terrain.set_cell(blockPosition,source_id,atlas["basaltBlockLIron"])
		#black.erase_cell(blockPosition)
		#black.erase_cell(blockPosition + Vector2i(0,1))
		#black.erase_cell(blockPosition + Vector2i(1,1))
		#black.erase_cell(blockPosition + Vector2i(1,0))
		#black.erase_cell(blockPosition + Vector2i(1,-1))
		#black.erase_cell(blockPosition + Vector2i(0,-1))
		#black.erase_cell(blockPosition + Vector2i(-1,-1))
		#black.erase_cell(blockPosition + Vector2i(-1,0))
		#black.erase_cell(blockPosition + Vector2i(-1,1))
