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




