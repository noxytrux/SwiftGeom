//
//  Matrix34.swift
//  SwiftGeom
//
//  Created by Marcin Pędzimąż on 27.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

import UIKit

struct Matrix34 {

    var M: Matrix33 = Matrix33()
    var t: Vector3 = Vector3()
    
    init(rot: Matrix33, trans: Vector3) {
    
        M = Matrix33(other: rot)
        t = Vector3(other: trans)
    }
    
    init(initialize: Bool) {

        if initialize {
        
            M.identity()
            t.zero()
        }
    }
}

extension Matrix34: Printable {
    
    //dispaly in column major (OpenGL like)
    var description: String {
        
        var row0 = "\(M[0,0]),\(M[1,0]),\(M[2,0])"
        var row1 = "\(M[0,1]),\(M[1,1]),\(M[2,1])"
        var row2 = "\(M[0,2]),\(M[1,2]),\(M[2,2])"
        var row3 = "\(t.x),\(t.y),\(t.z)"
        
        return "[\(row0),0.0,\n\(row1),0.0,\n\(row2),0.0,\n\(row3),1.0]"
    }
}

extension Matrix34 {

    mutating func zero() {
    
        M.zero()
        t.zero()
    }
    
    mutating func identity() {
    
        M.identity()
        t.zero()
    }
    
    func isIdentity() -> Bool {
    
        if M.isIdentity() == false {
        
            return false
        }
        
        if t.isZero() == false {
        
            return false
        }
        
        return true
    }
    
    func isFinite() -> Bool {
    
        if M.isFinite() == false {
        
            return false
        }
        
        if t.isFinite() == false {
        
            return false
        }
        
        return true
    }
    
    func getInverse(inout dest: Matrix34) -> Bool {
    
        var status = M.getInverse(&dest.M)
        dest.M.multiply(t * -1.0, dst: &dest.t)
        return status
    }
    
    func getInverseRT(inout dest: Matrix34) -> Bool {
    
        dest.M.setTransposed(M)
        dest.M.multiply(t * -1.0, dst: &dest.t)

        return true
    }
    
    func multiply(src: Vector3, inout dst: Vector3) {
    
        dst = M * src + t
    }
    
    func multiplyByInverseRT(src: Vector3, inout dst: Vector3) {
    
        M.multiplyByTranspose(src - t, dst: &dst)
    }
    
    mutating func multiply(left: Matrix34, right: Matrix34) {
    
        t = left.M * right.t + left.t
        M.multiply(left.M, right: right.M)
    }
    
    //MARK: raw data GET
    
    func getColumnMajor44(inout rawMatrix: [Float32]) {
    
        assert((rawMatrix.count == 16), "Error incompatibile matrix assigned")
        
        M.getColumnMajorStride4(&rawMatrix)
        
        rawMatrix[12] = t.x
        rawMatrix[13] = t.y
        rawMatrix[14] = t.z
        rawMatrix[3]  = 0.0
        rawMatrix[7]  = 0.0
        rawMatrix[11] = 0.0
        rawMatrix[15] = 1.0
    }
    
    func getRowMajor44(inout rawMatrix: [Float32]) {
        
        assert((rawMatrix.count == 16), "Error incompatibile matrix assigned")
    
        M.getRowMajorStride4(&rawMatrix)
        
        rawMatrix[3] = t.x
        rawMatrix[7] = t.y
        rawMatrix[11] = t.z
        rawMatrix[12] = 0.0
        rawMatrix[13] = 0.0
        rawMatrix[14] = 0.0
        rawMatrix[15] = 1.0
    }
    
    //MARK: raw data SET
    
    mutating func setColumnMajor44(rawMatrix: [Float32]) {
        
        assert((rawMatrix.count == 16), "Error incompatibile matrix assigned")
        
        M.setColumnMajorStride4(rawMatrix)
        
        t.x = rawMatrix[12]
        t.y = rawMatrix[13]
        t.z = rawMatrix[14]
    }
    
    mutating func setRowMajor44(rawMatrix: [Float32]) {
    
        assert((rawMatrix.count == 16), "Error incompatibile matrix assigned")
        
        M.setRowMajorStride4(rawMatrix)
        
        t.x = rawMatrix[3]
        t.y = rawMatrix[7]
        t.z = rawMatrix[11]
    }
    
}

func * (left: Matrix34, right: Matrix34) -> Matrix34 {

    var dest = Matrix34(initialize: false)
    dest.multiply(left,right: right)
    
    return dest
}

func * (left: Matrix34, right: Float32) -> Matrix34 {
    
    var dest = Matrix34(initialize: false)
    dest.t = left.t * right
    dest.M = left.M * right
    
    return dest
}

func + (left: Matrix34, right: Matrix34) -> Matrix34 {

    var dest = Matrix34(initialize: false)
    dest.t = left.t+right.t
    dest.M = left.M+right.M
    
    return dest
}

func *= (inout left: Matrix34, right: Matrix34) {

    left = left * right
}

func *= (inout left: Matrix34, right: Float32) {
    
    left = left * right
}

func += (inout left: Matrix34, right: Matrix34) {
    
    left = left + right
}
