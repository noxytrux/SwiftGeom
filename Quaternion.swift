//
//  Quaternion.swift
//  SwiftGeom
//
//  Created by Marcin Pędzimąż on 23.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

import UIKit

struct Quaternion {
    
    var x : Float32 = 0
    var y : Float32 = 0
    var z : Float32 = 0
    var w : Float32 = 0
    
    init() {
        x = 0
        y = 0
        z = 0
        w = 0
    }
    
    init(value: Float32) {
        
        x = value
        y = value
        z = value
        w = value
    }
    
    init(x:Float32, y:Float32, z:Float32, w:Float32) {
        
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    init(other: Quaternion) {
    
        x = other.x
        y = other.y
        z = other.z
        w = other.w
    }
    
    init(vector: Vector3, w _w: Float32) {
    
        x = vector.x
        y = vector.y
        z = vector.z
        w = _w
    }
    
    init(angle: Float32, axis: Vector3) {
    
        fromAngleAxis(angle, axis: axis)
    }
}

extension Quaternion: Printable {
    
    var description: String { return "[\(x),\(y),\(z),\(w)]" }
}

extension Quaternion {

    func isFinite() -> Bool {
        
        return x.isFinite && y.isFinite && z.isFinite && w.isFinite
    }
    
    mutating func fromAngleAxis(angle: Float32, axis: Vector3 ) {
    
        x = axis.x;
        y = axis.y;
        z = axis.z;
        
        let length =  1.0 / sqrt( x*x + y*y + z*z )
        
        x = x * length;
        y = y * length;
        z = z * length;
        
        let half = degToRad(angle * 0.5);
        
        w = cos(half);
        
        let sin_theta_over_two = sin(half);
        
        x = x * sin_theta_over_two;
        y = y * sin_theta_over_two;
        z = z * sin_theta_over_two;
    }
    
    mutating func invert() {
    
        x = -x
        y = -y
        z = -z
    }
    
    mutating func negate() {
    
        x = -x
        y = -y
        z = -z
        w = -w
    }
    
    mutating func zero() {
    
        x = 0
        y = 0
        z = 0
        w = 1
    }
    
    func isIdentityRotation() -> Bool {
    
        return x==0 && y==0 && z==0 && fabsf(w)==1;
    }
    
    func magnitude() -> Float32 {
        
        return sqrtf( x*x + y*y + z*z + w*w)
    }
    
    func magnitudeSquared() -> Float32 {
        
        return x*x + y*y + z*z + w*w
    }

    func getAngle() -> Float32 {
        
        return acos(w) * 2.0;
    }
    
    func getAngle(q:Quaternion) -> Float32 {
        
        return acos( dot(q) ) * 2.0;
    }

    func dot(v:Quaternion) -> Float32 {
        
        return x * v.x + y * v.y + z * v.z  + w * v.w;
    }

    mutating func normalize() {
        
        let mag = magnitude();
    
        if mag > 0 {
        
            let lenght = 1.0 / mag;
    
            x *= lenght;
            y *= lenght;
            z *= lenght;
            w *= lenght;
        }
    }

    mutating func conjugate() {
        
        x = -x;
        y = -y;
        z = -z;
    }
    
    mutating func set(other: Quaternion) {
        
        x = other.x
        y = other.y
        z = other.z
        w = other.w
    }
    
    mutating func slerp(t:Float32, left:Quaternion, right:Quaternion) {
    
        let quatEpsilon: Float32 = 1.0e-8
        
        self.set(left)
        
        var cosine: Float32 =
            x * right.x +
            y * right.y +
            z * right.z +
            w * right.w
        
        var sign: Float32 = 1.0
        
        if cosine < 0 {
            
            cosine = -cosine
            
            sign = -1.0
        }
        
        var sinus: Float32 = 1.0 - cosine*cosine
        
        if  sinus >= quatEpsilon*quatEpsilon {
            
            sinus = sqrt(sinus)
            
            var angle = atan2(sinus, cosine)
            var i_sin_angle = 1 / sinus
            
            var lower_weight = sin(angle*(1-t)) * i_sin_angle
            var upper_weight = sin(angle * t) * i_sin_angle * sign
            
            w = (w * (lower_weight)) + (right.w * (upper_weight))
            x = (x * (lower_weight)) + (right.x * (upper_weight))
            y = (y * (lower_weight)) + (right.y * (upper_weight))
            z = (z * (lower_weight)) + (right.z * (upper_weight))
        }

    }
    
    mutating func rotate(inout v: Vector3) {
   
        var myInverse = Quaternion()
        
        myInverse.x = -x
        myInverse.y = -y
        myInverse.z = -z
        myInverse.w =  w
        
        //v = ((*this) * v) ^ myInverse;
        
        var left = self * v
        
        v.x = left.w * myInverse.x + myInverse.w * left.x + left.y * myInverse.z - myInverse.y*left.z
        v.y = left.w * myInverse.y + myInverse.w * left.y + left.z * myInverse.x - myInverse.z*left.x
        v.z = left.w * myInverse.z + myInverse.w * left.z + left.x * myInverse.y - myInverse.x*left.y
    }
    
    func inverseRotate(inout v: Vector3) {
    
        var myInverse = Quaternion()
        
        myInverse.x = -x;
        myInverse.y = -y;
        myInverse.z = -z;
        myInverse.w =  w;
        
        //v = (myInverse * v) ^ (*this);
       
        var left = myInverse * v
        
        v.x = left.w*x + w*left.x + left.y*z - y*left.z
        v.y = left.w*y + w*left.y + left.z*x - z*left.x
        v.z = left.w*z + w*left.z + left.x*y - x*left.y
    }
    
    func rot(v: Vector3) -> Vector3 {
        
        var qv = Vector3(x: x,y: y,z: z)
        var crossDot = (qv.cross(v)) * w + qv * (qv.dot(v))
        
        return (v * (w*w - 0.5) + crossDot) * 2.0
    }
    
    func invRot(v: Vector3) -> Vector3 {
        
        var qv = Vector3(x: x,y: y,z: z)
        var crossDot = (qv.cross(v)) * w + qv * (qv.dot(v))
        
        return (v * (w*w - 0.5) - crossDot) * 2.0
    }

    func transform(v: Vector3, p: Vector3) -> Vector3 {
    
        return rot(v) + p
    }
    
    func invTransform(v: Vector3, p: Vector3) -> Vector3 {
    
        return invRot(v - p)
    }
}

func * (left: Quaternion, right : Quaternion) -> Quaternion {
    
    var a:Float32, b:Float32, c:Float32, d:Float32
    
    a =  -left.x*right.x - left.y*right.y - left.z * right.z
    b =   left.w*right.x + left.y*right.z - right.y * left.z
    c =   left.w*right.y + left.z*right.x - right.z * left.x
    d =   left.w*right.z + left.x*right.y - right.x * left.y
    
    return Quaternion(x: a, y: b, z: c, w: d)
}

func * (left: Quaternion, right : Vector3) -> Quaternion {
    
    var a:Float32, b:Float32, c:Float32, d:Float32

    a = -left.x*right.x - left.y*right.y - left.z * right.z;
    b =  left.w*right.x + left.y*right.z - right.y * left.z;
    c =  left.w*right.y + left.z*right.x - right.z * left.x;
    d =  left.w*right.z + left.x*right.y - right.x * left.y;
    
    return Quaternion(x: a, y: b, z: c, w: d)
}

func * (left: Quaternion, right : Float32) -> Quaternion {

    return Quaternion(x: left.x * right, y: left.y * right, z: left.z * right, w: left.w * right);
}

func + (left: Quaternion, right : Quaternion) -> Quaternion {
    
    return Quaternion(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z, w: left.w + right.w);
}

func - (left: Quaternion, right : Quaternion) -> Quaternion {
    
    return Quaternion(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z, w: left.w - right.w);
}



