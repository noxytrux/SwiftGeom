//
//  Matrix33.swift
//  Arpeggios
//
//  Created by Marcin Pędzimąż on 23.10.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

import UIKit

class Matrix33 {

    private let maxLenght = 3

    internal var m: [[Float32]] = [[0,0,0],[0,0,0],[0,0,0]]
    
    init() {
    
        zero()
    }
    
    init(row0: Vector3, row1: Vector3, row2: Vector3) {
    
        m[0][0] = row0.x
        m[0][1] = row0.y
        m[0][2] = row0.z
        
        m[1][0] = row1.x
        m[1][1] = row1.y
        m[1][2] = row1.z
        
        m[2][0] = row2.x
        m[2][1] = row2.y
        m[2][2] = row2.z
    }
    
    init(other: Matrix33) {
    
        m = [[Float32]](other.m)
    }
    
    init(q: Quaternion) {
    
        fromQuat(q)
    }

    subscript(row: Int, col: Int) -> Float32 {
    
        get {
            assert(indexIsValid(row, column: col), "Index out of range")
            return m[row][col]
        }
        
        set {
            assert(indexIsValid(row, column: col), "Index out of range")
            m[row][col] = newValue
        }
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        
        return row >= 0 && row < maxLenght && column >= 0 && column < maxLenght
    }
}

extension Matrix33 {

    func fromQuat(q: Quaternion) {
        
        let w = q.w;
        let x = q.x;
        let y = q.y;
        let z = q.z;
        
        self[0,0] = 1.0 - y*y*2.0 - z*z*2.0
        self[0,1] = x*y*2.0 - w*z*2.0
        self[0,2] = x*z*2.0 + w*y*2.0
        
        self[1,0] = x*y*2.0 + w*z*2.0
        self[1,1] = 1.0 - x*x*2.0 - z*z*2.0
        self[1,2] = y*z*2.0 - w*x*2.0
        
        self[2,0] = x*z*2.0 - w*y*2.0
        self[2,1] = y*z*2.0 + w*x*2.0
        self[2,2] = 1.0 - x*x*2.0 - y*y*2.0
    }
    
    func toQuat(inout q:Quaternion) {
        
        var tr:Float32, s:Float32
        
        tr = self[0,0] + self[1,1] + self[2,2]
    
        if(tr >= 0)
        {
            s =  sqrt(tr + 1)
            q.w = 0.5 * s
            s = 0.5 / s
            
            q.x = (m[2][1] - m[1][2]) * s
            q.y = (m[0][2] - m[2][0]) * s
            q.z = (m[1][0] - m[0][1]) * s
        }
        else
        {
            var i = 0
            
            if m[1][1] > m[0][0] {
                
                i = 1
            }

            if m[2][2] > m[i][i] {
           
                i = 2
            }
            
            switch (i)
            {
            case 0:
                s = sqrt((self[0,0] - (self[1,1] + self[2,2])) + 1)
                q.x = 0.5 * s
                s = 0.5 / s
                
                q.y = (self[0,1] + self[1,0]) * s
                q.z = (self[2,0] + self[0,2]) * s
                q.w = (self[2,1] - self[1,2]) * s
           
            case 1:
                s = sqrt((self[1,1] - (self[2,2] + self[0,0])) + 1)
                q.y = 0.5 * s
                s = 0.5 / s
                
                q.z = (self[1,2] + self[2,1]) * s
                q.x = (self[0,1] + self[1,0]) * s
                q.w = (self[0,2] - self[2,0]) * s
       
            case 2:
                s = sqrt((self[2,2] - (self[0,0] + self[1,1])) + 1)
                q.z = 0.5 * s
                s = 0.5 / s
                
                q.x = (self[2,0] + self[0,2]) * s
                q.y = (self[1,2] + self[2,1]) * s
                q.w = (self[1,0] - self[0,1]) * s
            
            default:
                ()
                break
            }
        }
    }
    
    func setColumn(col:Int, v:Vector3) {

        self[0,col] = v.x
        self[1,col] = v.y
        self[2,col] = v.z
    }
    
    func setRow(row:Int, v:Vector3) {
    
        self[row,0] = v.x
        self[row,1] = v.y
        self[row,2] = v.z
    }
    
    func getColumn(col:Int, inout v:Vector3) {
    
        v.x = self[0,col]
        v.y = self[1,col]
        v.z = self[2,col]
    }
    
    func getRow(row:Int, inout v:Vector3) {
    
        v.x = self[row,0]
        v.y = self[row,1]
        v.z = self[row,2]
    }
    
    func isIdentity() -> Bool {
        
        if self[0,0] != 1.0 { return false }
        if self[0,1] != 0.0 { return false }
        if self[0,2] != 0.0 { return false }
        
        if self[1,0] != 0.0 { return false }
        if self[1,1] != 1.0 { return false }
        if self[1,2] != 0.0 { return false }
        
        if self[2,0] != 0.0 { return false }
        if self[2,1] != 0.0 { return false }
        if self[2,2] != 1.0 { return false }
        
        return true;
    }

    func zero() {
    
        m[0][0] = 0
        m[0][1] = 0
        m[0][2] = 0
        
        m[1][0] = 0
        m[1][1] = 0
        m[1][2] = 0
        
        m[2][0] = 0
        m[2][1] = 0
        m[2][2] = 0
    }
    
    func identity() {
        
        m[0][0] = 1
        m[0][1] = 0
        m[0][2] = 0
        
        m[1][0] = 0
        m[1][1] = 1
        m[1][2] = 0
        
        m[2][0] = 0
        m[2][1] = 0
        m[2][2] = 1
    }
    
    func negative() {
    
        m[0][0] = -m[0][0]
        m[0][1] = -m[0][1]
        m[0][2] = -m[0][2]
        
        m[1][0] = -m[1][0]
        m[1][1] = -m[1][1]
        m[1][2] = -m[1][2]
        
        m[2][0] = -m[2][0]
        m[2][1] = -m[2][1]
        m[2][2] = -m[2][2]
    }
    
    func diagonal(v: Vector3) {
     
        m[0][0] = v.x
        m[0][1] = 0
        m[0][2] = 0
        
        m[1][0] = 0
        m[1][1] = v.y
        m[1][2] = 0
        
        m[2][0] = 0
        m[2][1] = 0
        m[2][2] = v.z
    }
    
    func star(v: Vector3) {
     
        m[0][0] =  0.0
        m[0][1] = -v.z
        m[0][2] =  v.y
        
        m[1][0] =  v.z
        m[1][1] =  0.0
        m[1][2] = -v.x
        
        m[2][0] = -v.y
        m[2][1] =  v.x
        m[2][2] =  0.0
    }
    
    func setTransposed(inout other: Matrix33) {
    
        if self === other {

            setTransposed()
        }
        else {
        
            self[0,0] = other[0,0]
            self[0,1] = other[1,0]
            self[0,2] = other[2,0]
            
            self[1,0] = other[0,1]
            self[1,1] = other[1,1]
            self[1,2] = other[2,1]
            
            self[2,0] = other[0,2]
            self[2,1] = other[1,2]
            self[2,2] = other[2,2]
        }
    }
    
    func setTransposed() {
    
        swapValues(&self[0,1], &self[1,0])
        swapValues(&self[1,2], &self[2,1])
        swapValues(&self[0,2], &self[2,0])
    }
    
    func multiplyDiagonal(v: Vector3) {
    
        m[0][0] *=  v.x
        m[0][1] *=  v.y
        m[0][2] *=  v.z
        
        m[1][0] *=  v.x
        m[1][1] *=  v.y
        m[1][2] *=  v.z
        
        m[2][0] *=  v.x
        m[2][1] *=  v.y
        m[2][2] *=  v.z
    }
    
    func multiplyDiagonalTranspose(d: Vector3) {
    
        var temp: Float32 = 0

        m[0][0] = m[0][0] * d.x
        m[1][1] = m[1][1] * d.y
        m[2][2] = m[2][2] * d.z
        
        temp = m[1][0] * d.y
        m[1][0] = m[0][1] * d.x
        m[0][1] = temp
        
        temp = m[2][0] * d.z
        m[2][0] = m[0][2] * d.x
        m[0][2] = temp
        
        temp = m[2][1] * d.z
        m[2][1] = m[1][2] * d.y
        m[1][2] = temp
    }

    //MARK: vector multiply

    func multiply(src: Vector3, inout dst: Vector3) {
    
        var x:Float32,y:Float32,z:Float32
        
        x = m[0][0] * src.x + m[0][1] * src.y + m[0][2] * src.z
        y = m[1][0] * src.x + m[1][1] * src.y + m[1][2] * src.z
        z = m[2][0] * src.x + m[2][1] * src.y + m[2][2] * src.z
        
        dst.x = x;
        dst.y = y;
        dst.z = z;
    }
    
    func multiplyByTranspose(src: Vector3, inout dst: Vector3) {
    
        var x:Float32,y:Float32,z:Float32;
        
        x = m[0][0] * src.x + m[1][0] * src.y + m[2][0] * src.z
        y = m[0][1] * src.x + m[1][1] * src.y + m[2][1] * src.z
        z = m[0][2] * src.x + m[1][2] * src.y + m[2][2] * src.z
        
        dst.x = x;
        dst.y = y;
        dst.z = z;
    }
    
    //MARK: matrix multiply
    
    
}

func + (left: Matrix33, right: Matrix33) -> Matrix33 {
    
    var outMatrix = Matrix33()
    
    outMatrix[0,0] = left[0,0] + right[0,0]
    outMatrix[0,1] = left[0,1] + right[0,1]
    outMatrix[0,2] = left[0,2] + right[0,2]
    
    outMatrix[1,0] = left[1,0] + right[1,0]
    outMatrix[1,1] = left[1,1] + right[1,1]
    outMatrix[1,2] = left[1,2] + right[1,2]
    
    outMatrix[2,0] = left[2,0] + right[2,0]
    outMatrix[2,1] = left[2,1] + right[2,1]
    outMatrix[2,2] = left[2,2] + right[2,2]
    
    return outMatrix
}

func - (left: Matrix33, right: Matrix33) -> Matrix33 {
   
    var outMatrix = Matrix33()
    
    outMatrix[0,0] = left[0,0] - right[0,0]
    outMatrix[0,1] = left[0,1] - right[0,1]
    outMatrix[0,2] = left[0,2] - right[0,2]
    
    outMatrix[1,0] = left[1,0] - right[1,0]
    outMatrix[1,1] = left[1,1] - right[1,1]
    outMatrix[1,2] = left[1,2] - right[1,2]
    
    outMatrix[2,0] = left[2,0] - right[2,0]
    outMatrix[2,1] = left[2,1] - right[2,1]
    outMatrix[2,2] = left[2,2] - right[2,2]
    
    return outMatrix
}


