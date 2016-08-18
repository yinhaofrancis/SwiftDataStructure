import UIKit

indirect enum List<T>:ArrayLiteralConvertible{
    case item(T,List<T>)
    case none
    init(arrayLiteral elements: List.Element...) {
        self = List<Element>.init(array: elements)
    }
    init(array:Array<Element>){
        self = List<Element>.init(arrayslice: array[0 ... array.count - 1] )
    }
    init(arrayslice:ArraySlice<Element>){
        switch arrayslice.count {
        case 0:
            self = .none
        default:
            let n = List<T>(arrayslice: arrayslice[1...arrayslice.count - 1])
            self = .item(arrayslice.first!,n)
        }
    }
    typealias Element = T
}

let k:List<Int> = [1,2,3,4,5,6,7,8,9]