import math

type
  # Position in 2D space
  Vector2D* = object
    x*, y*: float

proc `+`*(a, b: Vector2D): Vector2D =
  Vector2D(x: a.x + b.x, y: a.y + b.y)

proc `-`*(a, b: Vector2D): Vector2D =
  Vector2D(x: a.x - b.x, y: a.y - b.y)

proc `*`*(v: Vector2D, scalar: float): Vector2D =
  Vector2D(x: v.x * scalar, y: v.y * scalar)

proc magnitude*(v: Vector2D): float =
  sqrt(v.x * v.x + v.y * v.y)

proc normalize*(v: Vector2D): Vector2D =
  let mag = v.magnitude()
  if mag > 0.0001:
    Vector2D(x: v.x / mag, y: v.y / mag)
  else:
    Vector2D(x: 0.0, y: 0.0)

proc distance*(a, b: Vector2D): float =
  (b - a).magnitude()
