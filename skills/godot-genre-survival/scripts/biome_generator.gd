class_name BiomeGenerator extends Node

var _biome_noise: FastNoiseLite

func _ready() -> void:
    _biome_noise = FastNoiseLite.new()
    _biome_noise.seed = randi() 
    _biome_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
    _biome_noise.fractal_octaves = 5
    _biome_noise.frequency = 0.05

## Samples the noise at a specific coordinate to determine the biome type.
func get_biome_at_coordinate(x: float, y: float) -> String:
    var noise_val: float = _biome_noise.get_noise_2d(x, y)
    
    if noise_val < -0.25:
        return "Deep_Ocean"
    elif noise_val < 0.0:
        return "Shallow_Water"
    elif noise_val < 0.4:
        return "Forest"
    else:
        return "Mountain"
