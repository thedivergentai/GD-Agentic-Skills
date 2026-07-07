import os
import re
import sys

def score_modernity(project_path):
    print(f"--- Anara Insight: Modernity Index (Elite) ---")
    print(f"Reference: See Anara Rubrics #1 (Modernity & Primitives)")
    score = 50 

    # 1. Primitives (Godot 4.7)
    typed_containers = 0
    threaded_loading = 0
    compute_rd = 0
    area_light_3d = 0
    image_unit_api = 0
    legacy_richtext = 0
    
    for root, _, files in os.walk(project_path):
        for file in files:
            if file.endswith('.gd'):
                with open(os.path.join(root, file), 'r', encoding='utf-8') as f:
                    content = f.read()
                    typed_containers += len(re.findall(r':\s*(Array|Dictionary)\[', content))
                    threaded_loading += len(re.findall(r'ResourceLoader\.load_threaded_request', content))
                    compute_rd += len(re.findall(r'RenderingServer\.create_local_rendering_device', content))
                    area_light_3d += len(re.findall(r'AreaLight3D', content))
                    image_unit_api += len(re.findall(r'ImageUnit', content))
                    legacy_richtext += len(re.findall(r'width_in_percent|height_in_percent', content))

    # Weighting
    score += (typed_containers * 2)
    score += (threaded_loading * 15)
    score += (compute_rd * 20)
    score += (area_light_3d * 10)
    score += (image_unit_api * 5)
    score -= (legacy_richtext * 15)
    
    # Penalties for legacy patterns
    if "yield(" in content:
        score -= 30
        print("LEGACY SLOP: 'yield' detected. Godot 4 uses 'await'.")

    score = max(0, min(100, score))
    print(f"Modernity Score: {score}/100")
    print(f"Notes: {threaded_loading} threaded loaders, {compute_rd} compute devices found.")
    return score

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "."
    score_modernity(path)
