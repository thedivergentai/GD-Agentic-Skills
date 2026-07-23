extends RefCounted
class_name TurnPredictor
## Simulate ATB gauges to predict upcoming turn order for timeline UI.

static func predict_turns(actors: Array, count: int, step: float = 0.1) -> Array:
	var timeline: Array = []
	var sim_data: Array[Dictionary] = []
	for a in actors:
		sim_data.append({
			"id": a,
			"gauge": a.atb_gauge if "atb_gauge" in a else 0.0,
			"speed": a.speed if "speed" in a else 1.0,
		})
	while timeline.size() < count:
		for s in sim_data:
			s.gauge += s.speed * step
			if s.gauge >= 100.0:
				timeline.append(s.id)
				s.gauge = 0.0
				if timeline.size() >= count:
					break
	return timeline
