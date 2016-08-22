//
//  main.swift
//  d
//
//  Created by YinHao on 16/8/10.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
import CoreImage

var k  = RBTree<Int>()

for i in [13,8,17,1,11,15,25,6,22,27]{
    k.insert(i)
}
k.display()