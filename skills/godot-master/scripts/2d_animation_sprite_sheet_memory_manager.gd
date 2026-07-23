class_name SpriteSheetMemoryManager extends Node

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var _pending_path: String = ""
var _target_anim: StringName = &"heavy_attack"

func load_high_res_anim(path: String) -> void:
    _pending_path = path
    # 1. Start background loading to prevent frame stutter
    ResourceLoader.load_threaded_request(_pending_path)
    set_process(true)

func _process(_delta: float) -> void:
    # 2. Check loading status
    var status = ResourceLoader.load_threaded_get_status(_pending_path)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        var tex: Texture2D = ResourceLoader.load_threaded_get(_pending_path)
        _apply_to_frames(tex)
        set_process(false)

func _apply_to_frames(tex: Texture2D) -> void:
    var frames: SpriteFrames = animated_sprite.sprite_frames
    if not frames.has_animation(_target_anim):
        frames.add_animation(_target_anim)
    
    # 3. Inject frame dynamically
    frames.add_frame(_target_anim, tex)
    animated_sprite.play(_target_anim)

func unload_high_res_anim() -> void:
    var frames: SpriteFrames = animated_sprite.sprite_frames
    if frames.has_animation(_target_anim):
        # 4. Breaking the reference to the Texture2D frees it from RAM
        frames.clear(_target_anim)
