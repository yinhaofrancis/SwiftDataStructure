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
//        let matrix:Matrix4_4 = (
//            (0,0,0,0.4),
//            (0,0,0.4,0.8),
//            (0,0,0.4,1),
//            (0,1,1,1)
//        )
        if #available(iOS 9.0, *) {
            let image = (NoiseReduction(nil, sharpness: nil) + ColorCrossPolynomial(ColorCoefficients(red: [1], green: [0,1], blue: [0,0,1])))(Cii!)
            self.image.image = UIImage(CIImage: image)
        } else {
            // Fallback on earlier versions
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

