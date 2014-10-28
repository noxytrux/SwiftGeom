SwiftGeom
=========

Math, Vector and Matrix library for your 3D Swift project / game.

# Genesis

Because Swift does not currently handles unions there is no way you can use simd library in your swift project. You can also try to build some wrapper between objC and Swift but why? Currently there is a big lack of any kind of Vector and Matrix lib in Swift so I decided to write my own. (Yeah, GLKit stuff is also removed so no GLKVector , GLMatrix etc.)

## Implemented:

* Vector2
* Vector3
* Quaternion
* Matrix33
* Matrix34
* Matrix Utils

## Examples:

**Vector operations**

```ruby
  
  //simple calculation:

  var sunPosition = Vector3(x: 5.316387,y: -2.408824,z: 0)
  var sunVector = Vector3()
  var sunColor = Vector3()
    
  var orangeColor = Vector3(x: 1.0, y: 0.5, z: 0.0)
  var yellowColor = Vector3(x: 1.0, y: 1.0, z: 0.8)
    
  sunVector = Vector3( x: -cosf(sunPosition.x) * sinf(sunPosition.y),
                       y: -cosf(sunPosition.y),
                       z: -sinf(sunPosition.x) * sinf(sunPosition.y))
        
  var sun_cosy = sunVector.y
  var factor = 0.25 + sun_cosy * 0.75
        
  sunColor = ((orangeColor * (1.0 - factor)) + (yellowColor * factor))
    
  //other example:  
  
  let ev = Vector3(other: eye)
  let cv = Vector3(other: center)
  let uv = Vector3(other: up)
    
  cv.setNegative()
    
  var n: Vector3 = ev + cv
      n.normalize()
    
  var u: Vector3 = uv.cross(n)
      u.normalize()
    
  var v: Vector3 = n.cross(u)

  var un = u.copy() as Vector3
  var vn = v.copy() as Vector3
  var nn = n.copy() as Vector3
    
  un.setNegative()
  vn.setNegative()
  nn.setNegative()
    
  var m = [u.x, v.x, n.x, 0.0,
           u.y, v.y, n.y, 0.0,
           u.z, v.z, n.z, 0.0,
           un.dot(ev), vn.dot(ev), nn.dot(ev), 1.0]
    
```

**Quaternion**

```ruby
  var vecA = Vector3(value: 1)
  var vecB = Vector3(x: 0.3, y: 0.4, z: 0.5)
        
  var rotQuat = Quaternion(angle: Float32(M_PI_2), axis: Vector3(x: 1.0, y: 0.5, z: 0.0))
        
  rotQuat.rotate(&vecA)
        
  var vecC = Vector3(x: 0.2, y: 0.2, z: 0.5)
        
  var tramsformed = rotQuat.transform(vecB, p: vecC)
```
