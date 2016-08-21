import Foundation
enum NodeColor {
    case Red
    case Black
}
func ==<T> (l:TreeNode<T>,r:TreeNode<T>)->Bool{
    let ll = unsafeAddressOf(l)
    let rr = unsafeAddressOf(r)
    if ll == rr{
        return true
    }
    return false
}
class TreeNode<Element>:Equatable{
    var element:Element?
    var color:NodeColor = .Red
    var left:TreeNode<Element>?
    var parent:TreeNode<Element>?
    var right:TreeNode<Element>?
    init(){
        self.element = nil
        self.color = .Black
        self.parent = nil
    }
    init(element:Element,left:TreeNode<Element>,right:TreeNode<Element>,parent:TreeNode<Element>){
        self.element = element
        self.left = left
        self.right = right
        self.parent = parent
        self.color = .Red
    }
    var isNil:Bool{
        if let _ = self.element{
            return false
        }
        return true
    }
    func see(){
        if self.isNil{
            return
        }
        print(self.element,self.color)
        self.left?.see()
        self.right?.see()
    }
}
class RBTree<Element:Comparable>{
    private var root:TreeNode = TreeNode<Element>()
    func insert(element:Element){
        if root.isNil{
            self.root = TreeNode(element: element, left: TreeNode(), right: TreeNode(),parent: TreeNode())
            fixRBD(root)
        }else{
            if let node = RBTree.insert(root, e: element){
                fixRBD(node)
            }
        }
    }
    private static func insert(target:TreeNode<Element>,e:Element)->TreeNode<Element>?{
        if target.element < e{
            if target.right!.isNil{
                let node = TreeNode(element: e,left: TreeNode(),right: TreeNode(),parent: target)
                target.right = node
                node.parent = target
                return node
            }else{
                return RBTree.insert(target.right!, e: e)
            }
        }
        else if target.element > e{
            if target.left!.isNil{
                let node = TreeNode(element: e,left: TreeNode(),right: TreeNode(),parent: target)
                target.left = node
                node.parent = target
                return node
            }else{
                return RBTree.insert(target.left!, e: e)
            }
        }else{
            return nil
        }
    }
    private func rotationRight(node:TreeNode<Element>){
        let x = node
        let y = node.left
        x.left = y?.right
        y?.right = x
        x.left?.parent = x
        y?.parent = x.parent
        x.parent = y
        if y?.parent?.left == x{
            y?.parent?.left = y
        }else{
            y?.parent?.right = y
        }
        if node == root{
            root = y!
        }
    }
    private func rotationLeft(node:TreeNode<Element>){
        let y = node
        let x = node.right
        y.right = x?.left
        x?.left = y
        y.right?.parent = y
        x?.parent = y.parent
        y.parent = x
        if x?.parent?.left == y{
            x?.parent?.left = x
        }else{
            x?.parent?.right = x
        }
        if node == root{
            root = x!
        }
        
    }
    private func fixRB(n:TreeNode<Element>){
        var node = n
        if node.parent?.parent == nil || node.parent!.parent!.isNil{
            return
        }
        while node.parent!.color == .Red {
            if node.parent == node.parent?.parent?.left{
                let y = node.parent?.parent?.right
                if y?.color == .Red{
                    node.parent!.color = .Black
                    y?.color = .Black
                    node.parent?.parent?.color = .Red
                    node = (node.parent?.parent)!
                }
                else if node == node.parent?.right{
                    node = node.parent!
                    rotationLeft(node)
                }
                node.parent?.color = .Black
                node.parent?.parent?.color = .Red
                if node.parent?.parent != nil && !node.parent!.parent!.isNil{
                    rotationRight(node.parent!.parent!)
                }
            }else{
                let y = node.parent?.parent?.left
                if y?.color == .Red{
                    node.parent!.color = .Black
                    y?.color = .Black
                    node.parent?.parent?.color = .Red
                    node = (node.parent?.parent)!
                }
                else if node == node.parent?.left{
                    node = node.parent!
                    rotationRight(node)
                }
                node.parent?.color = .Black
                node.parent?.parent?.color = .Red
                
                if node.parent?.parent != nil && !node.parent!.parent!.isNil{
                    rotationLeft(node.parent!.parent!)
                }
            }
            self.root.color = .Black
        }
    }
    func fixRBD(node:TreeNode<Element>){
        var n = node
        while n.parent?.color == .Red {
            if n.parent == n.parent?.parent?.left{
                let m = n.parent?.parent?.right
                if m?.color == .Red{
                    n.parent?.color = .Black
                    m?.color = .Black
                    n.parent?.parent?.color = .Red
                    n = (n.parent?.parent)!
                }else if n == n.parent?.right{
                    n = n.parent!
                    rotationLeft(n)
                }
                n.parent?.color = .Black
                n.parent?.parent?.color = .Red
                if n.parent?.parent != nil{
                    rotationRight(n.parent!.parent!)
                }
            }else if n.parent == n.parent?.parent?.right{
                let m = n.parent?.parent?.left
                if m?.color == .Red{
                    n.parent?.color = .Black
                    m?.color = .Black
                    n.parent?.parent?.color = .Red
                    n = n.parent!.parent!
                }else if n == n.parent?.right{
                    n = n.parent!
                    rotationRight(n)
                }
                n.parent?.color = .Black
                n.parent?.parent?.color = .Red
                if n.parent?.parent != nil{
                    rotationLeft(n.parent!.parent!)
                }
            }
            self.root.color = .Black
        }
    }
    func display(){
        self.root.see()
    }
}