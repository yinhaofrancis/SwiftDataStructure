//
//  nViewController.swift
//  d
//
//  Created by YinHao on 16/8/17.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES
class nViewController: UIViewController {

    @IBOutlet weak var gv: GLKView!
    let context = EAGLContext(API: .OpenGLES2)
    var link:CADisplayLink?
    var  pip: Context? = nil
    var texture:CIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        gv.context = context
        let a = (PhotoEffectChrome() + PhotoEffectInstant() + ContextOpenGL(self.gv.context))
//        self.gv.bindDrawable()
        pip = a
        EAGLContext.setCurrentContext(context)
        let i  =  UIImage(named: "d")!
        texture = CIImage(image:i)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            self.setup()
        }
        
        // Do any additional setup after loading the view.
    }
    func setup(){
        link = CADisplayLink(target: self, selector: #selector(k))
        let runloop = NSRunLoop.currentRunLoop()
        link?.addToRunLoop(runloop, forMode: NSDefaultRunLoopMode)
        runloop.run()
        link?.frameInterval = 10
        k()
    }
    func k(){
        pip!(texture)(CGRect(x: 0,y: 0,width: 320 * UIScreen.mainScreen().scale,height: 320 * UIScreen.mainScreen().scale))
        self.gv.display()
    }
    override func viewDidDisappear(animated: Bool) {
        link?.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
