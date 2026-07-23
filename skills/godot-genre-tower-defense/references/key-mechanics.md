# Key Mechanics Implementation

### Targeting Math (Projectile Prediction)
To hit a moving target, you must predict where it will be.

```gdscript
func get_predicted_position(target: Node2D, projectile_speed: float) -> Vector2:
    var to_target = target.global_position - global_position
    var time_to_hit = to_target.length() / projectile_speed
    return target.global_position + (target.velocity * time_to_hit)
```

### Economy
Money management is the secondary core loop.
*   **Kill Rewards**: Direct feedback for success.
*   **Interest/Income**: Rewarding saved money (risk/reward).
*   **Early Calling**: Bonus money for starting the next wave early.
