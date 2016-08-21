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

for i in [11,2,14,1,7,15,5,8,4]{
    k.insert(i)
}
k.display()