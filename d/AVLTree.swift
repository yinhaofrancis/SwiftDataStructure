//
//  RBTree.swift
//  d
//
//  Created by YinHao on 16/8/12.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
enum NodeColor{
    case red
    case black
}
indirect enum AVLTree<Element:Comparable> {
    case Node(element:Element,left:AVLTree<Element>,right:AVLTree<Element>)
    case Leaf
    init (value:Element,left:AVLTree<Element>,right:AVLTree<Element>){
        self = .Node(element: value, left: left, right: right)
    }
    init(){
        self = .Leaf
    }
    mutating func insert(element:Element){
        guard case .Node(let e,var l,var r) = self else{
            self = AVLTree<Element>(value: element,left: .Leaf,right: .Leaf)
            return
        }
        if element > e{
            r.insert(element)
        }else {
            l.insert(element)
        }
        self = AVLTree(value: e, left: l, right: r)
        if l.depth - r.depth > 1{
            self.rotationRight()
        }
        if r.depth - l.depth > 1{
            self.rotationLeft()
        }
    }
    func see(){
        guard case let .Node(e,l,r) = self else{
            return
        }
        print(e)
        l.see()
        
        r.see()
        
    }
    mutating func rotationLeft(){
        guard case let .Node(e,l,r) = self else{
            return
        }
        guard case let .Node(re,el,rr) = r else{
            return
        }
        self = AVLTree(value: re, left: AVLTree(value: e,left: l,right: el), right: rr)
    }
    mutating func rotationRight(){
        guard case let .Node(e,l,r) = self else{
            return
        }
        guard case let .Node(le,ll,lr) = l else{
            return
        }
        self  = AVLTree(value: le, left: ll, right: AVLTree(value: e,left: lr,right: r))
    }
    var depth:Int{
        guard case let .Node(_,l,r) = self else{
            return 0
        }
        return max(l.depth, r.depth) + 1
    }
}
