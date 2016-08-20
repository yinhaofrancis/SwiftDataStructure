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
        self = AVLTree<Element>(value: e,left: l,right:r)
    }
    mutating func delete(filter: Element->Bool){
        if case  .Node(let e,var l,var r) = self{
            if filter(e){
                l.delete(filter)
                r.delete(filter)
                self = AVLTree(value: e, left: l, right: r)
                if filter(e){
                    self.delete()
                }
            }
        }        
    }
    private mutating func delete()->AVLTree<Element>{
        let temp = self
        guard case .Node(_,let l,var r)  = self else{
            return .Leaf
        }
        if case .Leaf = l {
            self = l
            return temp
        }
        if case .Leaf = r {
            self = r
            return temp
        }else{
            if case let .Node(e,l,r) = r,case .Leaf = l{
                if case let .Node(_,ll,_) = self{
                    self = AVLTree(value: e,left: ll,right: r)
                    return temp
                }else{
                    return temp
                }
            }
            else{
                let min = r.deleteMin()
                self = AVLTree(value: min, left: l, right: r)
                return temp
            }
        }
    }
    mutating func deleteMin()->Element{
        guard case .Node(let e,var l,let r) = self else{
            fatalError("tree is nil")
        }
        if case .Leaf = l{
            self = r
            return e
        }else{
            let rs = l.deleteMin()
            self = AVLTree(value: e, left: l, right: r)
            return rs
        }
    }
    var maxNode:AVLTree<Element>{
        guard case let .Node(_,_,r) = self else{
            fatalError("tree is nil")
        }
        guard case .Leaf = r else{
            return self
        }
        return self.maxNode
    }
    var minNode:AVLTree<Element>{
        guard case let .Node(_,l,_) = self else{
            fatalError("tree is nil")
        }
        guard case .Leaf = l else{
            return self
        }
        return self.minNode
    }
    func see(){
        guard case let .Node(e,l,r) = self else{
            return
        }
        
        l.see()
        print(e)
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
