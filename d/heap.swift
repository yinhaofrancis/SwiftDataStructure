//
//  heap.swift
//  d
//
//  Created by YinHao on 16/8/25.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
class heap<T:Comparable>:ArrayLiteralConvertible{
    typealias Element = T
    private var array:[Element]
    required init(arrayLiteral elements: heap.Element...) {
        self.array = elements
    }
    init(){
        array = []
    }
    func append(element:Element){
        self.array.append(element)
        heapfy(self.array.count / 2 - 1)
    }
    private func heapfy(to:Int){
        for i in 0 ... to{
            let j = to  - i
            if
        }
    }
    private func exchange(index:Int,index1:Int){
        let t = array[index]
        array[index] = array[index1]
        array[index1] = t
    }
    private func leftChild(index:Int)->Int?{
        let indexn = 2 * index + 1
        guard indexn < self.array.count else{
            return nil
        }
        return indexn
    }
    private rightChild(index:Index)
}