//
//  tree.swift
//  d
//
//  Created by YinHao on 16/8/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation

indirect enum BinaryTree<Element> {
    case Node(left:BinaryTree<Element>,element:Element,right:BinaryTree<Element>)
    case leaf
    init(value:Element){
        self = .Node(left: .leaf, element: value, right: .leaf)
    }
    init(){
        self = .leaf
    }
}
extension SequenceType{
    func all(predicate:Generator.Element->Bool)->Bool{
        for i in self where !predicate(i) {
            return false
        }
        return true
    }
}
extension BinaryTree{
    var count:Int{
        get{
            switch self {
            case .leaf:
                return 0
            case let .Node(left: l, element: _, right: r):
                return 1 + l.count + r.count
            }
        }
    }
    var elements:[Element]{
        get{
            switch self {
            case .leaf:
                return []
            case let .Node(left:l,element:e,right:r):
                return l.elements + [e] + r.elements
            }
        }
    }
    var isEmpty:Bool{
        if case.leaf = self{
            return false
        }
        return true
    }
}
extension BinaryTree where Element:Comparable{
    var isBST:Bool{
        switch self {
        case .leaf:
            return true
        case let .Node(left: l, element: e, right: r):
            return l.elements.all({e > $0}) && l.isBST && r.elements.all({e < $0}) && r.isBST
        }
    }
    func contain(element:Element)->Bool{
        switch self {
        case .leaf:
            return false
        case let .Node(left:_,element:e ,right:_) where element == e:
            return true
        case let .Node(left:l,element:e ,right:_) where element < e:
            return l.contain(e)
        
        case let .Node(left:_,element:e ,right:r) where element > e:
            return r.contain(e)
        default:
            fatalError("unknow error")
        }
    }
    mutating func insert(element:Element){
        switch self {
        case .leaf:
            self = BinaryTree(value: element)
        case .Node(var l, let e, var r):
            if element > e{
                r.insert(element)
            }
            if element < e{
                l.insert(element)
            }
            self = .Node(left: l, element: e, right: r)
        }
    }
}
extension BinaryTree{
    func display(){
        switch self {
        case .leaf:
            return
        case let .Node(r,e,l):
            print(e)
            l.display()
            r.display()
        }
    }
}