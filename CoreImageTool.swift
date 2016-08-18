//
//  CoreImageTool.swift
//  d
//
//  Created by YinHao on 16/8/16.
//  Copyright © 2016年 Suzhou Qier Network Technology Co., Ltd. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit
import CoreImage



typealias Filter = CIImage -> CIImage

typealias Stability = CIImage -> CGImage

typealias Context = CIImage -> CGRect? ->Void

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
extension CIFilter{
    func setVector(vector:Vector2?,name:String){
        if let v = vector{
            setValue(CIVector(vector: v), forKey: name)
        }
    }
    func setVector(vector:Vector3?,name:String){
        if let v = vector{
            setValue(CIVector(vector: v), forKey: name)
        }
    }
    func setVector(vector:Vector4?,name:String){
        if let v = vector{
            setValue(CIVector(vector: v), forKey: name)
        }
    }
    func setColor(vector:Vector4?,name:String){
        if let v = vector{
            setValue(CIColor(color: v), forKey: name)
        }
    }
}



func + <X,Y,Z>(A: X->Y, B:Y->Z)->X->Z{
    return {return B(A($0))}
}

struct PictureProcess{
    
    static func BoxBlur(radius:Float?)->Filter{
        let filter = CIFilter(name: "CIBoxBlur")
        filter?.setValue(radius, forKey: "inputRadius")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return (filter!.outputImage!)
        }
    }
    
    
    static func DiscBlur(radius:Float?)->Filter{
        let filter = CIFilter(name: "CIDiscBlur")
        filter?.setValue(radius, forKey: "inputRadius")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return (filter!.outputImage!)
        }
    }
    
    
    static func GaussianBlur(radius:Float?)->Filter{
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(radius, forKey: "inputRadius")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return (filter!.outputImage!)
        }
    }
    
    
    static func ExposureAdjust(EV:Float?)->Filter{
        let filter = CIFilter(name: "CIExposureAdjust")
        filter?.setValue(EV, forKey: "inputEV")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return (filter!.outputImage!)
        }
    }
    
    
    static func ColorControls(Saturation:Float?,Brightness:Float?,Contrast:Float?)->Filter{
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
    static func MedianFilter()->Filter{
        let filter = CIFilter(name: "CIMedianFilter")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    
    @available(iOS 9.0,*)
    static func MotionBlur(radius:Float?,angle:Float?)->Filter{
        let filter = CIFilter(name: "CIMotionBlur")
        filter?.setValue(radius, forKey: "inputRadius")
        filter?.setValue(angle, forKey: "inputAngle")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    
    @available(iOS 9.0,*)
    static func NoiseReduction(NoiseLevel:Float?,sharpness:Float?)->Filter{
        let filter = CIFilter(name: "CINoiseReduction")!
        filter.setValue(NoiseLevel, forKey: "inputNoiseLevel")
        filter.setValue(sharpness, forKey: "inputSharpness")
        return {
            filter.setValue($0, forKey: "inputImage")
            return filter.outputImage!
        }
    }
    
    
    static func ZoomBlur(center:Vector2?,amount:Float)->Filter{
        let filter = CIFilter(name: "CIZoomBlur")
        filter?.setVector(center, name: "inputCenter")
        filter?.setValue(amount, forKey: "inputAmount")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    
    static func ColorClamp(min:Vector4?,max:Vector4?)->Filter{
        let filter = CIFilter(name: "CIColorClamp")
        filter?.setVector(min, name: "inputMinComponents")
        filter?.setVector(max, name: "inputMaxComponents")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func ColorMatrix(matrix:Matrix4_4 = IdentityMatrix4_4,bias:Vector4 = (0,0,0,0))->Filter{
        let filter = CIFilter(name: "CIColorMatrix")
        filter?.setVector(matrix.0, name: "inputRVector")
        filter?.setVector(matrix.1, name: "inputGVector")
        filter?.setVector(matrix.2, name: "inputBVector")
        filter?.setVector(matrix.3, name: "inputAVector")
        
        filter?.setValue(CIVector(vector: bias), forKey: "inputBiasVector")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    
    static func ColorPolynomial(matrix:Matrix4_4 = CoefficientsMatrix4_4)->Filter{
        
        let filter = CIFilter(name: "CIColorPolynomial")
        filter?.setVector(matrix.0, name: "inputRedCoefficients")
        filter?.setVector(matrix.1, name: "inputGreenCoefficients")
        filter?.setVector(matrix.2, name: "inputBlueCoefficients")
        filter?.setVector(matrix.3, name: "inputAlphaCoefficients")
        return{
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    
    static func GammaAjust(gamma:Float?)->Filter{
        let filter = CIFilter(name: "CIGammaAdjust")
        filter?.setValue(gamma, forKey: "inputPower")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return (filter!.outputImage!)
        }
    }
    
    
    static func HueAdjust(angle:Float?)->Filter{
        
        let filter = CIFilter(name: "CIHueAdjust")
        filter?.setValue(angle, forKey: "inputAngle")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return (filter!.outputImage!)
        }
    }
    
    
    static func LinearToSRGBToneCurve()->Filter{
        let filter = CIFilter(name: "CILinearToSRGBToneCurve")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func SRGBToneCurveToLinear()->Filter{
        let filter = CIFilter(name: "CISRGBToneCurveToLinear")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func TemperatureAndTint(Neutral:Vector2?,TargetNeutral:Vector2?)->Filter{
        let filter = CIFilter(name: "CITemperatureAndTint")
        filter?.setVector(Neutral, name: "inputNeutral")
        filter?.setVector(TargetNeutral, name: "inputTargetNeutral")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func ToneCurve(p0:Vector2 = (0,0),
                   p1:Vector2 = (0.25,0.25),
                   p2:Vector2 = (0.5,0.5),
                   p3:Vector2 = (0.75,0.75),
                   p4:Vector2 = (1,1))->Filter{
        let filter = CIFilter(name: "CIToneCurve")
        filter?.setVector(p0, name: "inputPoint0")
        filter?.setVector(p1, name: "inputPoint1")
        filter?.setVector(p2, name: "inputPoint2")
        filter?.setVector(p3, name: "inputPoint3")
        filter?.setVector(p4, name: "inputPoint4")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func Vibrance(Amount:Float?)->Filter{
        let filter = CIFilter(name: "CIVibrance")
        filter?.setValue(Amount, forKey: "inputAmount")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func WhitePointAdjust(color:Vector4) ->Filter{
        let filter = CIFilter(name: "CIWhitePointAdjust")
        filter?.setColor(color, name: "inputColor")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func ColorCrossPolynomial(coefficients:ColorCoefficients)->Filter{
        let filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(CIVector(values: coefficients.red.fill(0)(10),count: 10), forKey: "inputRedCoefficients")
        filter?.setValue(CIVector(values: coefficients.green.fill(0)(10),count: 10), forKey: "inputGreenCoefficients")
        filter?.setValue(CIVector(values: coefficients.blue.fill(0)(10),count: 10), forKey: "inputBlueCoefficients")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    //static func ColorCube(CubeDimension:Int,@noescape data:(b:Int,g:Int,r:Int)->(Float,Float,Float,Float))->Filter{
    //    var mdata:[Float] = []
    //    for b in 0 ..< CubeDimension{
    //        for g in 0 ..< CubeDimension{
    //            for r in 0 ..< CubeDimension {
    //                let colorInfo = data(b: b, g: g, r: r)
    //                let colorList = [colorInfo.0,colorInfo.1,colorInfo.2,colorInfo.3]
    //                mdata += colorList
    //            }
    //        }
    //    }
    //    let filter = CIFilter(name: "CIColorCube")
    //    filter?.setValue(CubeDimension, forKey: "inputCubeDimension")
    //    print(mdata)
    //    return {
    //        let colorData = NSData(bytesNoCopy: &mdata, length: sizeof(Float) * CubeDimension * CubeDimension * CubeDimension, freeWhenDone: false)
    //        filter?.setValue(colorData, forKey: "inputCubeData")
    //        filter?.setValue($0, forKey: "inputImage")
    //        return filter!.outputImage!
    //    }
    //}
    
    static func ColorInvert()->Filter{
        let filter = CIFilter(name: "CIColorInvert")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func ColorMap(GradientImage:CIImage)->Filter{
        let  filter = CIFilter(name: "CIColorMap")
        filter?.setValue(GradientImage, forKey: "inputGradientImage")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func ColorMonochrome(color:Vector4?,Intensity:Float?)->Filter{
        let filter = CIFilter(name: "CIColorMonochrome")
        if let c  = color {
            filter?.setValue(CIColor(color:c), forKey: "inputColor")
        }
        filter?.setValue(Intensity, forKey: "inputIntensity")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func ColorPosterize(levels:Float?)->Filter{
        let filter = CIFilter(name: "CIColorPosterize")
        filter?.setValue(levels, forKey: "inputLevels")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func FalseColor(color1:Vector4,color2:Vector4)->Filter{
        let filter = CIFilter(name: "CIFalseColor")
        filter?.setColor(color1, name: "inputColor0")
        filter?.setColor(color2, name: "inputColor1")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func MaskToAlpha()->Filter{
        let filter = CIFilter(name: "CIMaskToAlpha")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func MaximumComponent()->Filter{
        let filter = CIFilter(name: "CIMaximumComponent")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func MinimumComponent()->Filter{
        let filter = CIFilter(name: "CIMinimumComponent")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func PhotoEffectChrome()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    static func PhotoEffectFade()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectFade")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    static func PhotoEffectInstant()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectInstant")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func PhotoEffectMono()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectMono")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func PhotoEffectNoir()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func PhotoEffectProcess()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func PhotoEffectTonal()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectTonal")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    
    static func PhotoEffectTransfer()->Filter{
        let filter = CIFilter(name: "CIPhotoEffectTransfer")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func SepiaTone(Intensity:Float?)->Filter{
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(Intensity, forKey: "inputIntensity")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func Vignette(Radius:Float?,Intensity:Float?)->Filter{
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(Intensity, forKey: "inputIntensity")
        filter?.setValue(Radius, forKey: "inputRadius")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    static func VignetteEffect(Center:Vector2,Radius:Float?,Intensity:Float?)->Filter{
        let filter = CIFilter(name: "CIVignetteEffect")
        filter?.setVector(Center, name: "inputCenter")
        filter?.setValue(Intensity, forKey: "inputIntensity")
        filter?.setValue(Radius, forKey: "inputRadius")
        return {
            filter?.setValue($0, forKey: "inputImage")
            return filter!.outputImage!
        }
    }
    
    @available(iOS 9.0,*)
    static func ContextCoreGraphics(context:CGContext) -> Context {
        let ctx = CIContext(CGContext: context, options: nil)
        return { image in
            return {
                let start = CGPointZero
                CGContextSaveGState(context)
                CGContextRotateCTM(context, 0)
                CGContextScaleCTM(context, 1, 1)
                CGContextTranslateCTM(context, 0, 0)
                CGContextScaleCTM(context, 1, -1)
                
                if let rect = $0{
                    CGContextTranslateCTM(context, 0, CGFloat(-rect.height))
                    let origin = CGPointApplyAffineTransform(rect.origin, CGAffineTransformMakeScale(1, -1))
                    ctx.drawImage(image, inRect: CGRect(origin: origin,size: rect.size), fromRect: image.extent)
                }else{
                    let width = CGBitmapContextGetWidth(context) / Int(UIScreen.mainScreen().scale)
                    let height = CGBitmapContextGetWidth(context) / Int(UIScreen.mainScreen().scale)
                    CGContextTranslateCTM(context, 0, CGFloat(-height))
                    ctx.drawImage(image, inRect: CGRect(origin: start,size: CGSize(width: width,height: height)), fromRect: image.extent)
                }
                CGContextRestoreGState(context)
            }
        }
        
    }
    
    static func ContextOpenGL(context:EAGLContext)->Context{
        let ctx = CIContext(EAGLContext: context)
        return{ image in
            return{
                guard let rect = $0 else{
                    return
                }
                ctx.drawImage(image, inRect: rect, fromRect: image.extent)
            }
            
        }
    }
    
    static func render(context:CIContext)->Stability{
        return { image in
            return context.createCGImage(image, fromRect: image.extent)
        }
    }

}