//
//  main.swift
//  d
//
//  Created by YinHao on 16/8/10.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
import CoreImage

func exchange<X,Y,Z>(a:X->Y->Z)->Y->X->Z{
    return { y in
        return { x in
            return a(x)(y)
        }
    }
}
func add(i:Int)->String->String{
    return { s in
        return "\(i)" + s
    }
}


let k:List<String> = ["a","a","a","b","b"]
//print(k.tail)
//print(k.initList)
//print(k.first)
//print(k.last)
//print(k[0])
//print(k.len)
//print(k.initList.tail)
//print(k.palindrome)
print(List.compress(k))