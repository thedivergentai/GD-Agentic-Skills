# big_real.gd
class_name BigReal extends RefCounted

@export var mantissa: float = 0.0
@export var exponent: int = 0

func _init(m: float = 0.0, e: int = 0) -> void:
    mantissa = m
    exponent = e
    _normalize()

func _normalize() -> void:
    if mantissa == 0.0:
        exponent = 0
        return
    while abs(mantissa) >= 10.0:
        mantissa /= 10.0
        exponent += 1
    while abs(mantissa) < 1.0 and mantissa != 0.0:
        mantissa *= 10.0
        exponent -= 1

func multiply(other: BigReal) -> BigReal:
    return BigReal.new(mantissa * other.mantissa, exponent + other.exponent)
