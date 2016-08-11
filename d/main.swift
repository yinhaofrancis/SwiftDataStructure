//
//  main.swift
//  d
//
//  Created by YinHao on 16/8/10.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
var l = ChainList<Int>()
[1,2,3,4,5].forEach { (i) in
    l.addFirst(i)
}
l.insert(9, index: 2)
l.display()