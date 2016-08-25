//
//  heap.swift
//  d
//
//  Created by YinHao on 16/8/25.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
class heap<T:Comparable>:ArrayLiteralConvertible,CustomStringConvertible{
    typealias Element = T
    private var array:[Element]
    var filter:(a:Element,b:Element)->Bool = {$0 > $1}
    required convenience init(arrayLiteral elements: heap.Element...) {
        self.init(array: elements)
    }
    init(array:[Element]){
        self.array = array
        heapfy(self.array.count - 1,filter: filter)
    }
    init(){
        array = []
    }
    func append(element:Element){
        self.array.append(element)
        heapfy(self.array.count - 1,filter: filter)
    }
    private func heapfy(to:Int, filter:(a:Element,b:Element)->Bool){
        for i in 0 ... to - 1{
            let j = to  - i
            let p = parent(j)
            if filter(a: array[j],b: array[p!]){
                exchange(p!, index1: j)
            }else{
                continue
            }
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
    private func parent(index:Int)->Int?{
        if index <= 0{
            return nil
        }else{
            return index % 2 == 0 ? index / 2 - 1 : index / 2
        }
    }
    private func rightChild(index:Int)->Int?{
        let indexn = 2 * index + 2
        guard indexn < self.array.count else{
            return nil
        }
        return indexn
    }
    var topHeap:Element?{
        return self.array.first
    }
    func RemoveTop()->Element?{
        if array.isEmpty{
            return nil
        }
        let result = self.array.removeAtIndex(0)
        self.heapfy(self.array.count - 1, filter: filter)
        return result
    }
    func sort(){
        let n = self.array.count - 1
        for i in 0 ... n{
            let j = n - i
            self.exchange(0, index1: j)
            if j - 1 == 0{
                break
            }
            self.heapfy(j - 1, filter: filter)
        }
    }
    func toArray()->[Element]{
        return self.array
    }
    @warn_unused_result
    func map<U>(@noescape  translate:Element throws ->U) rethrows ->heap<U>{
        let a = try self.array.map(translate)
        return heap<U>(array: a)
    }
    var description: String{
        return array.description
    }
}