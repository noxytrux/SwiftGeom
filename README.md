SwiftGeom
=========

Math, Vector and Matrix library for your 3D Swift project / game.

Please keep in mind this is still under development so there may be some things missing.

# Genesis

Because Swift does not currently handles unions there is no way you can use simd library in your swift project. You can also try to build some wrapper between objC and Swift but why? Currently there is a big lack of any kind of Vector and Matrix lib in Swift so I decided to write my own. (Yeah, GLKit stuff is also removed so no GLKVector , GLMatrix etc.)

## Implemented:

* Vector2
* Vector3
* Quaternion
* Matrix33
* Matrix34
* Matrix Utils

## TODO:

* Matrix34 scaling
* Matrix34 set matrix[16] column major
* Matrix34 set matrix[16] row major
* Matrix33 set matrix[9] columm major
* Matrix33 set matrix[9] row major

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

**Matrix33**

```ruby
  var vecA = Vector3(value: 1)
        
  var rotQuat = Quaternion(x: 0.0, y: 0.5, z: 0.0, w: 1.0)
  var rotMatrix = Matrix33(q: rotQuat)
        
  var vecB = rotMatrix * vecA
        
  var rotX = Matrix33()
  var rotY = Matrix33()
  var rotZ = Matrix33()
        
  rotX.rotX(Float32(M_PI_4))
  rotY.rotY(Float32(M_PI_2))
  rotZ.rotZ(Float32(M_PI))
        
  var completeRotation = rotX * rotY * rotZ
        
  var outVec = Vector3()
        
  completeRotation.multiply(vecB, dst: &outVec)
```

**Matrix34**

```ruby
  var modelMatrix = Matrix34(initialize: true)
  var viewMatrix = Matrix34(initialize: true)
        
  var modelView = modelMatrix * viewMatrix
        
  var inverted = Matrix33()
  var normalMatrix = Matrix33(other: modelView.M)
        
  if modelView.M.getInverse(&inverted) == true {
        
    inverted.setTransposed(&normalMatrix)
  }
```

**Raw Matrix functions**

```ruby
  var projMatrix: [Float32]! = nil
  var viewMatrix: [Float32]! = nil
    
  var aspect = Float32(view.frame.size.width/view.frame.size.height)
  projMatrix = matrix44MakePerspective(degToRad(60), aspect, 0.01, 5000)
  viewMatrix = matrix44MakeLookAt(eyeVec, eyeVec + dirVec, upVec)
```
