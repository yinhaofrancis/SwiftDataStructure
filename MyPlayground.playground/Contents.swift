//: Playground - noun: a place where people can play

import Cocoa

typealias Request = NSURL -> String -> [String:AnyObject] -> [String:String] ->NSURLRequest?
func makeFunc(url:NSURL) -> String -> [String:AnyObject] -> [String:String] ->NSURLRequest?{
    return { method in
        return { body in
            return { header in
                let req = NSMutableURLRequest(URL: url)
                req.allHTTPHeaderFields = header
                req.HTTPMethod = method
                do{
                    req.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
                }catch{
                    return nil
                }
                return req
            }
        }
    }
}

func replicate<Element>(element:Element)->UInt->[Element]{
    func gen(count:UInt)->[Element]{
        switch count {
        case 0:
            return []
        default:
            return [element] + gen(count - 1)
        }
    }
    return gen
}
replicate(1)(10)
func zip<T,U>(left:[T])->[U] -> [(T,U)]{
    func inner(right:[U])->[(T,U)]{
        if left.count == 0{
            return []
        }else if right.count == 0{
            return []
        }else{
            return [(left.first!,right.first!)] + zip(Array(left.dropFirst()))(Array(right.dropFirst()))
        }
    }
    return inner
}
func quickSort<Element:Comparable>(list:[Element])->[Element]{
    switch list.count {
    case 0:
        return []
    default:
        let first = list.first!
        let small = quickSort(list.dropFirst().filter({$0 < first}))
        let big =  quickSort(list.dropFirst().filter({$0 >= first}))
        return small + [first] + big
    }
}
quickSort([4,3,1,2,5,9,5])

func + <X,Y,Z>(A: X->Y, B:Y->Z)->X->Z{
    return {return B(A($0))}
}

func add<T:IntegerType>(a:T)->T->T{
    return { a + $0 }
}
func mul<T:IntegerType>(a:T)->T->T{
    return { a * $0}
}
func addOne<T:IntegerType>(a:T)->T{
    return a + 1
}
(add(1) + mul(10) + add(11))(1)


extension Array{
    static func repeatWith(element:Element)->Int->[Element]{
        func repeatDo(count:Int)->[Element]{
            switch count {
            case 0:
                return []
            default:
                return [element] + repeatDo(count - 1)
            }
        }
        return repeatDo
    }
    func fill(element:Element)->Int->[Element]{
        return {
            if self.count < $0{
                let newArray = Array.repeatWith(element)($0 - self.count)
                return self + newArray
            }else{
                return self
            }
        }
    }
}
[1,2,3].fill(0)(10)