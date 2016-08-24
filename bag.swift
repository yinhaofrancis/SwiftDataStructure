//
//  bag.swift
//  f
//
//  Created by YinHao on 16/8/24.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
typealias state = (info:[Bool],weight:Int,value:Int)
func bag(value:[Int],weight:[Int],max:Int,inout field:[Int:state])->state{
    if max <= 0{
        return ((0 ..< value.count).map({_ in false}) ,0 ,0)
    }else if let k = field[max]{
        return k
    }else{
        var w = 0
        var v = 0
        var baginfo = (0 ..< value.count).map({_ in false})
        for i in 0 ..< value.count{
            let d = bag(value,weight: weight,max: max - weight[i],field: &field)
            if weight[i] > max{
                continue
            }
            if d.value + value[i] > v && d.info[i] == false{
                v = d.value + value[i]
                w = d.weight + weight[i]
                baginfo = d.info
                baginfo[i] = true
            }else if d.value > v{
                v = d.value
                w = d.weight
                baginfo = d.info
            }
        }
        field[max] = (baginfo,w,v)
        return (baginfo,w,v)
    }
}