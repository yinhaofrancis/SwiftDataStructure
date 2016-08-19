//
//  HSList.swift
//  d
//
//  Created by YinHao on 16/8/18.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation

indirect enum List<T>:ArrayLiteralConvertible{
    case item(T,List<T>)
    case none
    init(arrayLiteral elements: List.Element...) {
        self = List<Element>.init(array: elements)
    }
    init(array:Array<Element>){
        if array.count != 0 {
            self = List<Element>.init(arrayslice: array[0 ... array.count - 1] )
        }else{
            self = .none
        }
        
    }
    init(arrayslice:ArraySlice<Element>){
        switch arrayslice.count {
        case 0:
            self = .none
        case 1:
            self = .item(arrayslice.first!, .none)
        default:
            self = .item(arrayslice.first!,List<T>(arrayslice: arrayslice.dropFirst()))
        }
    }
    typealias Element = T
    var last:Element?{
        guard case let .item(e,next) = self else{
            return nil
        }
        switch next {
        case .none:
            return e
        default:
            return next.last
        }
    }
    var first:Element?{
        guard case let .item(e,_) = self else {
            return nil
        }
        return e
    }
    var initList:List<T>{
        switch self {
        case .none:
            return .none
            
        case let .item(e,n):
            switch n {
            case .none:
                return .none
            default:
                return .item(e,n.initList)
            }
        }
    }
    var tail:List<T>{
        guard case let .item(_ ,next) = self else {
            return .none
        }
        return List<T>(list: next)
    }
    init(element:Element,next:List<Element>){
        self = .item(element, next)
    }
    init(list:List<T>){
        switch list {
        case .none:
            self = .none
        case let .item(element, next):
            self = List<T>(element: element,next: List<T>(list: next))
        }
    }
    subscript (i:Int)->Element?{
        guard i == 0 else{
            return self.tail[i - 1]
        }
        return self.first
    }
    var len:Int{
        guard case .none = self else{
            return 1 + self.tail.len
        }
        return 0
    }
}
extension List where T:Equatable{
    var palindrome:Bool{
        guard case .none = self else{
            if self.first == self.last{
                return true && self.tail.initList.palindrome
            }
            return false
        }
        return true
    }
    static func compress(list:List<T>)->List<T>{
        switch list {
        case .none:
            return.none
        case let .item(e, next):
            if case let .item(f,_)  = next{
                if e == f{
                    return List.compress(next)
                }else{
                    return .item(e,List.compress(next))
                }
            }else{
                return .item(e,.none)
            }
        }
    }
}
