//
//  ChainList.swift
//  d
//
//  Created by YinHao on 16/8/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
indirect enum ChainListGenerator<T>{
    typealias RealNode = (T,ChainListGenerator<T>)
    case First(count:UInt,next:ChainListGenerator<T>?)
    case Node(element:T,next:ChainListGenerator<T>)
    case Empty(next:ChainListGenerator<T>?)
    
    
    init(count:UInt,next:ChainListGenerator<T>){
        self = .First(count: count,next:next)
    }
    init(element:T,next:ChainListGenerator<T>){
        self = .Node(element: element, next: next)
    }
    init(first:ChainListGenerator<T>?){
        self = .Empty(next: first)
    }
    func next()->ChainListGenerator<T>?{
        switch self {
        case let .Empty(n):
            return n
        case let .Node(_,n):
            return n
        case let .First(_,n):
            return n
        }
    }
    var isEmpty:Bool{
        guard case .Empty = self else{
            return false
        }
        return true
    }
}

struct ChainList<T>{
    typealias Generator = ChainListGenerator<T>
    private var first:Generator = Generator(first: nil)
    mutating func addFirst(element:T){
        if first.next() == nil{
            first = ChainListGenerator(count: 1, next: ChainListGenerator(element: element, next: first))
        }
        else{
            if case let .First(e,_) = first{
                first = ChainListGenerator(count: e + 1, next: ChainListGenerator(element: element, next: first.next()!))
            }
        }
    }
    mutating func append(element:T){
        if first.next() == nil{
            first = ChainListGenerator(count: 1, next: ChainListGenerator(element: element, next: first))
        }else{
            var temp = first.next()!
            while !temp.next()!.isEmpty {
                temp = temp.next()!
            }
        }
    }
    func display(){
        var n = first.next()
        while case let .Node(i,_) = n! {
            print(i)
            n = n?.next()
        }
    }
    var count:UInt{
        if case let .First(n,_) = first{
            return n
        }
        return 0
    }
}

