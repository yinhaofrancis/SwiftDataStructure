//
//  main.swift
//  d
//
//  Created by YinHao on 16/8/10.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
import CoreImage

var k  = AVLTree<Int>()

for i in [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]{
    k.insert(i)
}
k.see()
print(k)
print(k.depth)
