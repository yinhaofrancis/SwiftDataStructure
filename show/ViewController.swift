//
//  ViewController.swift
//  show
//
//  Created by YinHao on 16/8/16.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var orgin: UIImageView!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.orgin.image =  UIImage(named: "d")!
        let Cii = CIImage(image:self.orgin.image!)
        let  pip = PhotoEffectChrome() + PhotoEffectInstant() + render(CIContext(EAGLContext: EAGLContext(API: .OpenGLES2)))
        
        image.image = UIImage(CGImage: pip(Cii!))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
