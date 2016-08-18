////
////  List.swift
////  d
////
////  Created by YinHao on 16/8/12.
////  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
////
//
//import Foundation
//indirect enum List<Item>{
//    case Node(element:Element,next:List<Element>)
//    case Head(count:Int,next:List<Element>)
//    case Empty
//    init(){
//        self = .Head(count: 0, next: .Empty)
//    }
//    var count:Int{
//        get{
//            if case let .Head(c,_) = self{
//                return c
//            }
//            fatalError("this is not Head node")
//        }
//    }
//    mutating func append(element:Element){
//        if self.isEmpty {
//            self = List(element: element,next: .Empty)
//            return
//        }
//        self.next.append(element)
//        if self.isHead{
//            self.setCount(self.count + 1)
//        }
//    }
//    mutating func removeAtIndex(index:Int)->Element{
//        if self.isHead{
//            if index >= self.count{
//                fatalError("array is out of range")
//            }
//        }
//        if index <= 0{
//            let e = self.element
//            self = self.next.copy()
//            return e
//        }else{
//            if self.isHead{
//                self.setCount(self.count - 1)
//                return self.next.next.removeAtIndex(index - 1)
//            }else{
//                return self.next.removeAtIndex(index - 1)
//            }
//           
//        }
//    }
//    func copy()->List<Element>{
//        switch self {
//        case .Empty:
//            return .Empty
//        case let .Head(count: c, next: n):
//            return .Head(count:c,next:n)
//        case let Node(element: e, next: n):
//            return List<Element>(element: e, next: n)
//        }
//    }
//}
//extension List{
//    private init(element:Element,next:List<Element>){
//        self = .Node(element: element, next: next)
//    }
//    private var element:Element{
//        get{
//            if case let  .Node(e,_) = self{
//                return e
//            }
//            fatalError("this is not a node may is head or Empty")
//        }
//        set{
//            if case let  .Node(e,_) = self{
//                self = .Node(element: e, next: self.next)
//            }
//        }
//    }
//    private var next:List<Element>{
//        get{
//            if case let .Head(_,n) = self{
//                return n
//            }
//            if case let .Node(_,n) = self{
//                return n
//            }
//            fatalError("this is Empty")
//        }
//        set{
//            if case let .Head(c,_) = self{
//                self = .Head(count: c, next: newValue)
//                return
//            }
//            if case let .Node(e,_) = self{
//                self = .Node(element: e, next: newValue)
//                return
//            }
//            fatalError("this is Empty")
//        }
//    }
//    private mutating func setCount(count:Int){
//        if case let .Head(_,n) = self{
//            self = .Head(count:count,next:n)
//        }
//    }
//    private var isEmpty:Bool{
//        guard case .Empty  = self else{
//            return false
//        }
//        return true
//    }
//    private var isHead:Bool{
//        guard case .Head  = self else{
//            return false
//        }
//        return true
//    }
//    private func getElementIndex(index:Int)->Element{
//        if self.isHead{
//            guard self.count > index && index >= 0 else{
//                fatalError("out of range")
//            }
//        }
//        if index <= 0{
//            return self.element
//        }else{
//            if isHead{
//                return self.next.next.getElementIndex(index - 1)
//            }else{
//                return self.next.getElementIndex(index - 1)
//            }
//        }
//        
//    }
//}
//extension List:ArrayLiteralConvertible{
//    typealias Element = Item
//    init(arrayLiteral elements: List.Element...) {
//        var tmp = List<Element>()
//        elements.forEach({tmp.append($0)})
//        self = tmp
//    }
//    subscript (index:Int)->Element{
//        return getElementIndex(index)
//    }
//}