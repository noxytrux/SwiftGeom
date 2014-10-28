//
//  Math.swift
//  SwiftGeom
//
//  Created by Marcin Pędzimąż on 23.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

import UIKit

func degToRad(a: Float32) -> Float32 {
    
    return 0.01745329251994329547 * a;
}

func radToDeg(a: Float32) -> Float32 {
    
    return 57.29577951308232286465 * a;
}

func swapValues<T>(inout a: T, inout b: T) {
    
    let temp = a
    
    a = b
    b = temp
}

func matrix44MakePerspective(fovyRadians: Float32, aspect: Float32, nearZ: Float32, farZ: Float32) -> [Float32] {

    var cotan: Float32 = 1.0 / tanf(fovyRadians / 2.0);
    
    var m = [ cotan / aspect, 0.0, 0.0, 0.0,
              0.0, cotan, 0.0, 0.0,
              0.0, 0.0, (farZ + nearZ) / (nearZ - farZ), -1.0,
              0.0, 0.0, (2.0 * farZ * nearZ) / (nearZ - farZ), 0.0]
    
    return m
}

func matrix44MakeFrustum(left: Float32, right: Float32, bottom: Float32, top: Float32, nearZ: Float32, farZ: Float32) -> [Float32] {

    let ral = right + left;
    let rsl = right - left;
    let tsb = top - bottom;
    let tab = top + bottom;
    let fan = farZ + nearZ;
    let fsn = farZ - nearZ;
    
    //expression to loooooooooong...
    let a = 2.0 * nearZ / rsl
    let b = 2.0 * nearZ / tsb
    let c = ral / rsl
    let d = tab / tsb
    let e = -fan / fsn
    let f = (-2.0 * farZ * nearZ) / fsn
    
    var m = [ a, 0.0, 0.0, 0.0,
              0.0, b, 0.0, 0.0,
               c,  d,  e, -1.0,
              0.0, 0.0, f, 0.0]
    
    return m
}

func matrix44MakeOrtho(left: Float32, right: Float32, bottom: Float32, top: Float32, nearZ: Float32, farZ: Float32) -> [Float32] {
    
    let ral = right + left;
    let rsl = right - left;
    let tab = top + bottom;
    let tsb = top - bottom;
    let fan = farZ + nearZ;
    let fsn = farZ - nearZ;
    
    var m = [ 2.0 / rsl, 0.0, 0.0, 0.0,
              0.0, 2.0 / tsb, 0.0, 0.0,
              0.0, 0.0, -2.0 / fsn, 0.0,
              -ral / rsl, -tab / tsb, -fan / fsn, 1.0]
    
    return m
}

func matrix44MakeLookAt(eye: Vector3, center: Vector3, up: Vector3) -> [Float32]{
 
    let ev = Vector3(other: eye)
    let cv = Vector3(other: center)
    let uv = Vector3(other: up)
    
    cv.setNegative()
    
    var n: Vector3 = ev + cv
        n.normalize()
    
    var u: Vector3 = uv.cross(n)
        u.normalize()
    
    var v: Vector3 = n.cross(u)

    var un = Vector3(other: u)
    var vn = Vector3(other: v)
    var nn = Vector3(other: n)
    
    un.setNegative()
    vn.setNegative()
    nn.setNegative()
    
    var m = [u.x, v.x, n.x, 0.0,
             u.y, v.y, n.y, 0.0,
             u.z, v.z, n.z, 0.0,
             un.dot(ev), vn.dot(ev), nn.dot(ev), 1.0]
    
    return m
}

