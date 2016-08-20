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

for i in [4,2,6,1,3,5,7]{
    k.insert(i)
}
k.delete({$0 == 4})
k.see()

