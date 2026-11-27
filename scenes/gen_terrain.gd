extends Node

@onready var terrain: TileMapLayer = %Terrain
@onready var black: TileMapLayer = %Black
# around -0.15 to -0.9

# dirt color environment -> 24170a	
var source_id: int = 0

var atlas: Dictionary = {
	"dirt" = Vector2i(0,0),
	"barrier" = Vector2i(8,0),
	"clay" = Vector2i(0,1),
	"clayLCopper" = Vector2i(1,1),
	"sandstone" = Vector2i(0,2),
	"sandstoneLCopper" = Vector2i(1,2),
	"sandstoneHCopper" = Vector2i(2,2),
	"sandstoneLTin" = Vector2i(3,2),
	"sandstoneLCoal" = Vector2i(4,2),
	"sandstoneHCoal" = Vector2i(5,2),
	"shale" = Vector2i(0,3),
	"shaleLCopper" = Vector2i(1,3),
	"shaleLCoal" = Vector2i(2,3),
	"shaleHCoal" = Vector2i(3,3),
	"shaleLZinc" = Vector2i(4,3),
	"shaleHZinc" = Vector2i(5,3),
	"shaleLSilver" = Vector2i(6,3),
	"limestone" = Vector2i(0,4),
	"limestoneLCopper" = Vector2i(1,4),
	"limestoneHCopper" = Vector2i(2,4),
	"limestoneLZinc" = Vector2i(3,4),
	"limestoneHZinc" = Vector2i(4,4),
	"limestoneLSilver" = Vector2i(5,4),
	"basalt" = Vector2i(0,5),
	"basaltLCopper" = Vector2i(1,5),
	"basaltHCopper" = Vector2i(2,5),
	"basaltLIron" = Vector2i(3,5),
	"basaltHIron" = Vector2i(4,5),
	"basaltLZinc" = Vector2i(5,5),
	"basaltLTitanium" = Vector2i(6,5),
	"basaltLSilver" = Vector2i(7,5),
	"basaltHSilver" = Vector2i(8,5),
	"granite" = Vector2i(0,6),
	"graniteLTin" = Vector2i(1,6),
	"graniteHTin" = Vector2i(2,6),
	"graniteLIron" = Vector2i(3,6),
	"graniteLSilver" = Vector2i(4,6),
	"graniteHSilver" = Vector2i(5,6),
}


@export var heat_noise_node: NoiseTexture2D
@export var pressure_noise_node: NoiseTexture2D
@export var moisture_noise_node: NoiseTexture2D
@export var transition_noise_node: NoiseTexture2D
@export var additional_noise_node: NoiseTexture2D

var heatNoise : Noise
var pressureNoise : Noise
var moistureNoise : Noise
var transitionNoise : Noise
var additionalNoise : Noise

func _ready() -> void:
	
	var test: Array
	
	heatNoise = heat_noise_node.noise
	heatNoise.seed = randi_range(0,5000)
	pressureNoise = pressure_noise_node.noise
	pressureNoise.seed = randi_range(0,5000)
	moistureNoise = moisture_noise_node.noise
	moistureNoise.seed = randi_range(0,5000)
	transitionNoise = transition_noise_node.noise
	transitionNoise.seed = randi_range(0,5000)
	additionalNoise = additional_noise_node.noise
	additionalNoise.seed = randi_range(0,5000)
	
	create_layer(["layer0to1","layer1","layer1to2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2","layer2"])
	
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
				noise_value = transitionNoise.get_noise_2d(x+offset.x,y+offset.y)
				if noise_value > (-0.15 - y / 21.0):
					layer1_gen(Vector2i(x,y)+offset)
				else:
					layer0_gen(Vector2i(x,y)+offset)
	if type == "layer1":
		for x in range(16):
			for y in range(16):
				layer1_gen(Vector2i(x,y)+offset)
	if type == "layer1to2":
		for x in range(16):
			for y in range(16):
				noise_value = transitionNoise.get_noise_2d(x+offset.x,y+offset.y)
				if noise_value > (-0.15 - y / 21.0):
					layer2_gen(Vector2i(x,y)+offset)
				else:
					layer1_gen(Vector2i(x,y)+offset)
	if type == "layer2":
		for x in range(16):
			for y in range(16):
				layer2_gen(Vector2i(x,y)+offset)

func create_layer(layers: Array):
	var y: int = 0
	for type in layers:
		for x in range(-10,10):
			create_chunk(x,y,type)
		y += 1
		
func layer0_gen(blockPosition: Vector2i):
	var noise_value = moistureNoise.get_noise_2d(blockPosition.x,blockPosition.y*5)
	if noise_value > -0.55:
		noise_value = heatNoise.get_noise_2d(blockPosition.x*6,blockPosition.y*6)
		if noise_value > -0.6:
			terrain.set_cell(blockPosition,source_id,atlas["dirt"])
		else:
			noise_value = moistureNoise.get_noise_2d(blockPosition.x*6,blockPosition.y*6)
			if noise_value > -0.4:
				terrain.set_cell(blockPosition,source_id,atlas["clayLCopper"])
			else:
				terrain.set_cell(blockPosition,source_id,atlas["clay"])
	else:
		terrain.set_cell(blockPosition,source_id,atlas["dirt"])

func layer1_gen(blockPosition: Vector2i):
	var noise_value = moistureNoise.get_noise_2d(blockPosition.x*0.8,blockPosition.y*13)
	if noise_value > -0.49:
		terrain.set_cell(blockPosition,source_id,atlas["limestone"])
	elif noise_value > -0.6:
		terrain.set_cell(blockPosition,source_id,atlas["shale"])
	elif noise_value > -0.63:
		noise_value = pressureNoise.get_noise_2d(blockPosition.x*6,blockPosition.y*6)
		if noise_value > -0.38:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneHCopper"])
		elif noise_value > -0.5:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneLCopper"])
		else:
			terrain.set_cell(blockPosition,source_id,atlas["sandstone"])
	else:
		noise_value = heatNoise.get_noise_2d(blockPosition.x*4,blockPosition.y*4)
		if noise_value > -0.4:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneHCoal"])
		elif noise_value > -0.43:
			terrain.set_cell(blockPosition,source_id,atlas["sandstoneLCoal"])
		else:
			terrain.set_cell(blockPosition,source_id,atlas["sandstone"])
		
			
func layer2_gen(blockPosition: Vector2i):
	var noise_value = additionalNoise.get_noise_2d(blockPosition.x,blockPosition.y)
	if noise_value < 0.5:
		noise_value = heatNoise.get_noise_2d(blockPosition.x*6,blockPosition.y*10)
		if noise_value > -0.55:
			# basalt
			terrain.set_cell(blockPosition,source_id,atlas["basalt"])
			
		else:
			terrain.set_cell(blockPosition,source_id,atlas["granite"])
		# granite
		#black.erase_cell(blockPosition)
		#black.erase_cell(blockPosition + Vector2i(0,1))
		#black.erase_cell(blockPosition + Vector2i(1,1))
		#black.erase_cell(blockPosition + Vector2i(1,0))
		#black.erase_cell(blockPosition + Vector2i(1,-1))
		#black.erase_cell(blockPosition + Vector2i(0,-1))
		#black.erase_cell(blockPosition + Vector2i(-1,-1))
		#black.erase_cell(blockPosition + Vector2i(-1,0))
		#black.erase_cell(blockPosition + Vector2i(-1,1))
