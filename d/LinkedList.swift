//
//  ChainList.swift
//  d
//
//  Created by YinHao on 16/8/11.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation

indirect enum LinkedList<Item where Item:Comparable>{
    case Empty
    case Node(element:Item,next:LinkedList<Element>)
    var next:LinkedList<Element>?{
        guard case let .Node(_,n) = self else{
            return nil
        }
        return n
    }
    var element:Element?{
        guard case let .Node(d,_) = self else{
            return nil
        }
        return d
    }
    var isEmpty:Bool{
        guard case .Empty = self else{
            return false
        }
        return true
    }
    init(element:Element,next:LinkedList<Element>){
        self = .Node(element: element, next: next)
    }
    init(){
        self = .Empty
    }
    static func append(root:LinkedList<Element>,element:Element)->LinkedList<Element>{
        return  LinkedList.forEachDo(root, doSome: { $0.isEmpty ? LinkedList(element: element,next: LinkedList()):LinkedList(element: $0.element!,next: .Empty)})
    }
    
    private static func forEachDo(root:LinkedList<Element>,doSome:(LinkedList<Element>)->LinkedList<Element>)->LinkedList<Element>{
        switch root {
        case .Empty:
            return doSome(root)
        default:
            let new = doSome(root)
            if new.isEmpty && !root.next!.isEmpty{
                let next = forEachDo(root.next!, doSome: doSome)
                return LinkedList(element: next.element!, next: next.next!)
            }else{
                let next = forEachDo(root.next!, doSome: doSome)
                return copyAndAppend(new, last: next)
            }
            
            
        }
    }
    private static func copyAndAppend(root:LinkedList<Element>,last:LinkedList<Element>)-> LinkedList<Element>{
        switch root {
        case .Empty where !last.isEmpty:
            return LinkedList(element: last.element!, next: last.next!)
        case .Empty where last.isEmpty:
            return root
        default:
            return LinkedList(element: root.element!, next: copyAndAppend(root.next!,last: last))
        }
    }
}
extension LinkedList{
    static func remove(root:LinkedList<Element>,compare:(Element)->Bool)->LinkedList<Element>{
        return LinkedList.forEachDo(root, doSome: { (l) -> LinkedList<Element> in
            if !l.isEmpty && compare(l.element!){
                return .Empty
            }else if !l.isEmpty{
                return LinkedList(element: l.element!, next: LinkedList())
            }else{
                return LinkedList()
            }
        })
    }
    static func insert(root:LinkedList<Element>,element:Element,compare:(Element)->Bool)->LinkedList<Element>{
        return LinkedList.forEachDo(root, doSome: { (l) -> LinkedList<Element> in
            if !l.isEmpty && compare(l.element!){
                return LinkedList(element: element, next: LinkedList(element: l.element!, next: LinkedList()))
            }else if !l.isEmpty{
                return LinkedList(element: l.element!, next: LinkedList())
            }else{
                return LinkedList()
            }
        })
    }
}
extension LinkedList :ArrayLiteralConvertible{
    typealias Element = Item
    init(arrayLiteral elements: LinkedList.Element...) {
        self = LinkedList(elements: elements, index: 0)
    }
    private init(elements:[Element],index:Int){
        if index >= elements.count{
            self = LinkedList()
        }else{
            let e = elements[index]
            self = LinkedList(element:e, next: LinkedList(elements: elements, index: index + 1))
        }
    }

}