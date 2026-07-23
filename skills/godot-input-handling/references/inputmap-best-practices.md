# InputMap Best Practices

Avoid physical key checks. Define semantic actions (e.g., `move_left`, `interact`) in **Project Settings > Input Map**.

### 1. Analog Deadzones
Analog sticks suffer from drift. Use `Input.get_vector()` for mathematically correct **circular deadzones**.
- **Bad**: Subtracting axis strengths manually creates "square" deadzones.
- **Good**: `var input := Input.get_vector("left", "right", "up", "down")` applies a perfectly circular deadzone and clamps magnitude to 1.0.

### 2. Basic Polling

```gdscript
# Check if action pressed this frame
if Input.is_action_just_pressed("jump"):
    jump()

# Check if action held
if Input.is_action_pressed("fire"):
    shoot()

# Check if action released
if Input.is_action_just_released("jump"):
    release_jump()

# Get axis (-1 to 1)
var direction := Input.get_axis("move_left", "move_right")

# Get vector
var input_vector := Input.get_vector("left", "right", "up", "down")
```
