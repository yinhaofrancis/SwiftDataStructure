//
//  LineRegion.swift
//  d
//
//  Created by YinHao on 16/8/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation

typealias Region = CGPoint -> Bool
typealias Line = CGPoint ->Bool
extension CGPoint{
    func minus(offset:CGPoint)->CGPoint{
        return CGPoint(x: self.x - offset.x, y: self.y - offset.y)
    }
}
infix operator  ^ { associativity left precedence 160 }
func ^ (left:CGFloat,right:CGFloat)->CGFloat{
    return pow(left, right)
}
func circle(center:CGPoint,Distance:CGFloat)-> Region{
    return {point in
        sqrt((center.y - point.y)^2 + (center.x - point.x)^2) <= Distance
    }
}
func line(k:CGFloat)->Line{
    return {point in point.x * k == point.y}
}
func shiftLine(line:Line,offset:CGPoint)->Line{
    return {point in line(point.minus(offset))}
}
func shiftRegion(region:Region,offset:CGPoint)->Region{
    return { point in
        region(point.minus(offset))}
}