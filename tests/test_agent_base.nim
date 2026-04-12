import unittest
import ../src/core/agent_base

suite "Agent Base Tests":
  test "Vector2D Addition":
    let v1 = Vector2D(x: 1.0, y: 2.0)
    let v2 = Vector2D(x: 3.0, y: 4.0)
    let res = v1 + v2
    check(res.x == 4.0)
    check(res.y == 6.0)

  test "Vector2D Normalization":
    let v = Vector2D(x: 3.0, y: 4.0)
    let res = v.normalize()
    check(abs(res.magnitude() - 1.0) < 0.0001)

  test "wrapAround":
    var pos = Vector2D(x: 110.0, y: -10.0)
    wrapAround(pos, 100.0, 100.0)
    check(pos.x == 10.0)
    check(pos.y == 90.0)
