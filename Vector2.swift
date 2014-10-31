//
//  Vector2.swift
//  SwiftGeom
//
//  Created by Marcin Pędzimąż on 22.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

import UIKit

struct Vector2 {
    
    var x : Float32 = 0.0
    var y : Float32 = 0.0
    
    init() {
        
        x = 0.0
        y = 0.0
    }
    
    init(value: Float32) {
    
        x = value
        y = value
    }
    
    init(x:Float32,y:Float32) {
        
        self.x = x
        self.y = y
    }
    
    init(other: Vector2) {
    
        x = other.x
        y = other.y
    }
}

extension Vector2: Printable {
    
    var description: String { return "[\(x),\(y)]" }
}

extension Vector2 : Equatable {
    
    func isFinite() -> Bool {
    
        return x.isFinite && y.isFinite
    }

    func distance(other: Vector2) -> Float32 {
        
        let result = self - other;
        return sqrt( result.dot(result) )
    }
    
    mutating func normalize() {
        
        let m = magnitude()
        
        if m > 0 {
            
            let il:Float32 = 1.0 / m
            
            x *= il
            y *= il
        }
    }
    
    func magnitude() -> Float32 {
        
        return sqrtf( x*x + y*y )
    }
    
    func dot( v: Vector2 ) -> Float32 {
        
        return x * v.x + y * v.y
    }
    
    mutating func lerp( a: Vector2, b: Vector2, coef : Float32) {
        
        let result = a + ( b - a) * coef
        
        x = result.x
        y = result.y
    }
}

func ==(lhs: Vector2, rhs: Vector2) -> Bool {

    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

func * (left: Vector2, right : Float32) -> Vector2 {
    
    return Vector2(x:left.x * right, y:left.y * right)
}

func * (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x * right.x, y:left.y * right.y)
}

func / (left: Vector2, right : Float32) -> Vector2 {
    
    return Vector2(x:left.x / right, y:left.y / right)
}

func / (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x / right.x, y:left.y / right.y)
}

func + (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x + right.x, y:left.y + right.y)
}

func - (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x - right.x, y:left.y - right.y)
}

func + (left: Vector2, right: Float32) -> Vector2 {
    
    return Vector2(x:left.x + right, y:left.y + right)
}

func - (left: Vector2, right: Float32) -> Vector2 {
    
    return Vector2(x:left.x - right, y:left.y - right)
}

func += (inout left: Vector2, right: Vector2) {
    
    left = left + right
}

func -= (inout left: Vector2, right: Vector2) {
    
    left = left - right
}

func *= (inout left: Vector2, right: Vector2) {
    
    left = left * right
}

func /= (inout left: Vector2, right: Vector2) {
    
    left = left / right
}

