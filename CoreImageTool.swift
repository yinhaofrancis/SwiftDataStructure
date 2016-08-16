//
//  CoreImageTool.swift
//  d
//
//  Created by YinHao on 16/8/16.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
import CoreImage
typealias Filter = CIImage -> CIImage

typealias Vector2 = (CGFloat,CGFloat)

typealias Vector3 = (CGFloat,CGFloat,CGFloat)

typealias Vector4 = (CGFloat,CGFloat,CGFloat,CGFloat)

typealias Matrix4_4 = (Vector4,Vector4,Vector4,Vector4) // | Vector4 |
                                                        // | Vector4 |
                                                        // | Vector4 |
                                                        // | Vector4 |
typealias Coefficients = Array<CGFloat>
let IdentityMatrix4_4:Matrix4_4 = (
    (1,0,0,0),
    (0,1,0,0),
    (0,0,1,0),
    (0,0,0,1)
)

let CoefficientsMatrix4_4:Matrix4_4 = (
    (0,1,0,0),
    (0,1,0,0),
    (0,1,0,0),
    (0,1,0,0)
)
struct ColorCoefficients {
    var red:Coefficients = [1,0,0,0,0,0,0,0,0,0]
    var green:Coefficients = [0,1,0,0,0,0,0,0,0,0]
    var blue:Coefficients = [0,0,1,0,0,0,0,0,0,0]
}

func TranslateVector(matrix:Matrix4_4)->(CIVector,CIVector,CIVector,CIVector){
    return (CIVector(vector: matrix.0),
            CIVector(vector: matrix.1),
            CIVector(vector: matrix.2),
            CIVector(vector: matrix.3)
    )
}

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

extension CIVector{
    convenience init(vector:Vector2) {
        self.init(x: vector.0, y: vector.1)
    }
    convenience init(vector:Vector3) {
        self.init(x: vector.0, y: vector.1,z: vector.2)
    }
    convenience init(vector:Vector4) {
        self.init(x: vector.0, y: vector.1,z: vector.2,w: vector.3)
    }
}

extension CIColor {
    convenience init(color:Vector4) {
        self.init(red: color.0, green: color.1,blue: color.2,alpha: color.3)
    }
}

func + <X,Y,Z>(A: X->Y, B:Y->Z)->X->Z{
    return {return B(A($0))}
}

func BoxBlur(radius:Float?)->Filter{
    let filter = CIFilter(name: "CIBoxBlur")
    filter?.setValue(radius, forKey: "inputRadius")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return (filter!.outputImage!)
    }
}


func DiscBlur(radius:Float?)->Filter{
    let filter = CIFilter(name: "CIDiscBlur")
    filter?.setValue(radius, forKey: "inputRadius")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return (filter!.outputImage!)
    }
}


func GaussianBlur(radius:Float?)->Filter{
    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(radius, forKey: "inputRadius")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return (filter!.outputImage!)
    }
}


func ExposureAdjust(EV:Float?)->Filter{
    let filter = CIFilter(name: "CIExposureAdjust")
    filter?.setValue(EV, forKey: "inputEV")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return (filter!.outputImage!)
    }
}


func ColorControls(Saturation:Float?,Brightness:Float?,Contrast:Float?)->Filter{
    let filter = CIFilter(name: "CIColorControls")
    filter?.setValue(Saturation, forKey: "inputSaturation")
    filter?.setValue(Brightness, forKey: "inputBrightness")
    filter?.setValue(Contrast, forKey: "inputContrast")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}


@available(iOS 9.0,*)
func MedianFilter()->Filter{
    let filter = CIFilter(name: "CIMedianFilter")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}


@available(iOS 9.0,*)
func MotionBlur(radius:Float?,angle:Float?)->Filter{
    let filter = CIFilter(name: "CIMotionBlur")
    filter?.setValue(radius, forKey: "inputRadius")
    filter?.setValue(angle, forKey: "inputAngle")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}


@available(iOS 9.0,*)
func NoiseReduction(NoiseLevel:Float?,sharpness:Float?)->Filter{
    let filter = CIFilter(name: "CINoiseReduction")!
    filter.setValue(NoiseLevel, forKey: "inputNoiseLevel")
    filter.setValue(sharpness, forKey: "inputSharpness")
    return {
        filter.setValue($0, forKey: "inputImage")
        return filter.outputImage!
    }
}


func ZoomBlur(center:Vector2,amount:Float)->Filter{
    let filter = CIFilter(name: "CIZoomBlur")
    filter?.setValue(CIVector(vector: center), forKey: "inputCenter")
    filter?.setValue(amount, forKey: "inputAmount")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}


func ColorClamp(min:Vector4?,max:Vector4?)->Filter{
    let filter = CIFilter(name: "CIColorClamp")
    if let m = min{
        filter?.setValue(CIVector(vector: m), forKey: "inputMinComponents")
    }
    if let m = max {
        filter?.setValue(CIVector(vector: m), forKey: "inputMaxComponents")
    }
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func ColorMatrix(matrix:Matrix4_4 = IdentityMatrix4_4,bias:Vector4 = (0,0,0,0))->Filter{
    let filter = CIFilter(name: "CIColorMatrix")
    let m = TranslateVector(matrix)
    filter?.setValue(m.0, forKey: "inputRVector")
    filter?.setValue(m.1, forKey: "inputGVector")
    filter?.setValue(m.2, forKey: "inputBVector")
    filter?.setValue(m.3, forKey: "inputAVector")
    filter?.setValue(CIVector(vector: bias), forKey: "inputBiasVector")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}


func ColorPolynomial(matrix:Matrix4_4 = CoefficientsMatrix4_4)->Filter{
    let m = TranslateVector(matrix)
    let filter = CIFilter(name: "CIColorPolynomial")
    filter?.setValue(m.0, forKey: "inputRedCoefficients")
    filter?.setValue(m.1, forKey: "inputGreenCoefficients")
    filter?.setValue(m.2, forKey: "inputBlueCoefficients")
    filter?.setValue(m.3, forKey: "inputAlphaCoefficients")
    return{
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}


func GammaAjust(gamma:Float?)->Filter{
    let filter = CIFilter(name: "CIGammaAdjust")
    filter?.setValue(gamma, forKey: "inputPower")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return (filter!.outputImage!)
    }
}


func HueAdjust(angle:Float?)->Filter{
    
    let filter = CIFilter(name: "CIHueAdjust")
    filter?.setValue(angle, forKey: "inputAngle")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return (filter!.outputImage!)
    }
}


func LinearToSRGBToneCurve()->Filter{
    let filter = CIFilter(name: "CILinearToSRGBToneCurve")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func SRGBToneCurveToLinear()->Filter{
    let filter = CIFilter(name: "CISRGBToneCurveToLinear")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func TemperatureAndTint(Neutral:Vector2 = (6500,0),TargetNeutral:Vector2 = (6500,0))->Filter{
    let filter = CIFilter(name: "CITemperatureAndTint")
    filter?.setValue(CIVector(vector: Neutral), forKey: "inputNeutral")
    filter?.setValue(CIVector(vector: TargetNeutral), forKey: "inputTargetNeutral")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func ToneCurve(p0:Vector2 = (0,0),
               p1:Vector2 = (0.25,0.25),
               p2:Vector2 = (0.5,0.5),
               p3:Vector2 = (0.75,0.75),
               p4:Vector2 = (1,1))->Filter{
    let filter = CIFilter(name: "CIToneCurve")
    filter?.setValue(CIVector(vector: p0), forKey: "inputPoint0")
    filter?.setValue(CIVector(vector: p1), forKey: "inputPoint1")
    filter?.setValue(CIVector(vector: p2), forKey: "inputPoint2")
    filter?.setValue(CIVector(vector: p3), forKey: "inputPoint3")
    filter?.setValue(CIVector(vector: p4), forKey: "inputPoint4")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func Vibrance(Amount:Float?)->Filter{
    let filter = CIFilter(name: "CIVibrance")
    filter?.setValue(Amount, forKey: "inputAmount")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func WhitePointAdjust(color:Vector4) ->Filter{
    let filter = CIFilter(name: "CIWhitePointAdjust")
    filter?.setValue(CIColor(color:color), forKey: "inputColor")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

func ColorCrossPolynomial(coefficients:ColorCoefficients)->Filter{
    let filter = CIFilter(name: "CIColorCrossPolynomial")
    filter?.setValue(CIVector(values: coefficients.red.fill(0)(10),count: 10), forKey: "inputRedCoefficients")
    filter?.setValue(CIVector(values: coefficients.green.fill(0)(10),count: 10), forKey: "inputGreenCoefficients")
    filter?.setValue(CIVector(values: coefficients.blue.fill(0)(10),count: 10), forKey: "inputBlueCoefficients")
    return {
        filter?.setValue($0, forKey: "inputImage")
        return filter!.outputImage!
    }
}

