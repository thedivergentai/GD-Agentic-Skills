class_name WorldStreamer extends Node

var load_queue: Array[String] = []

func request_chunk(path: String) -> void:
    # Begin background thread request
    var err = ResourceLoader.load_threaded_request(path)
    if err == OK:
        load_queue.append(path)

func _process(_delta: float) -> void:
    for i in range(load_queue.size() - 1, -1, -1):
        var path = load_queue[i]
        var status = ResourceLoader.load_threaded_get_status(path)
        
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            # Resource ready! Instantiate and add to scene
            var chunk: PackedScene = ResourceLoader.load_threaded_get(path)
            add_child(chunk.instantiate())
            load_queue.remove_at(i)
