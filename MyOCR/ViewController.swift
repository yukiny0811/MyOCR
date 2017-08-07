//
//  ViewController.swift
//  MyOCR
//
//  Created by 桑島侑己 on 2017/08/05.
//  Copyright © 2017年 桑島侑己. All rights reserved.
//

import UIKit
import SwiftOCR
import AVFoundation

/*
 what I changed
 cropSize 2 ~ 9
 
 
 
 
 
 
 */

extension UIImage{
    func detectOrientationDegree() -> CGFloat{
        switch imageOrientation{
        case .right, .rightMirrored:
            return 90
        case .left, .leftMirrored:
            return -90
        case .up, .upMirrored:
            return 180
        case .down, .downMirrored:
            return 0
        }
    }
}
class ViewController: UIViewController {
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var viewFinder: UIView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var label: UILabel!
    
    var stillImageOutput: AVCaptureStillImageOutput!
    let captureSession = AVCaptureSession()
    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let ocrInstance = SwiftOCR()
    
    let saveData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            if self.device != nil {
                self.configureCameraForUse()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func takePhotoButtonPressed (_ sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async {
            let capturedType = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo)
            self.stillImageOutput.captureStillImageAsynchronously(from: capturedType) { [weak self] buffer, error -> Void in
                if buffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    let image = UIImage(data: imageData!)
                    let croppedImages = self?.prepareImageForCrop(using: image!, make81: true)
                    
//                    for img in 0...8 {
//                        self?.ocrInstance.recognize(croppedImages![img]) { [weak self] recognizedString in
//                            DispatchQueue.main.async {
////                                self?.label.text = recognizedString
//                                self?.saveData.set(recognizedString, forKey: "save\(img)")
//                                print(self?.ocrInstance.currentOCRRecognizedBlobs ?? "Recoginzed Blob is empty")
//                            }
//                        }
//                    }
//                    self?.labelText()
                    var recognizedStringArray: [[String]] = []
                    for y in 0...8{
                        var tempArray: [String] = []
                        for x in 0...8{
                            self?.ocrInstance.recognize(croppedImages![y][x]) { [weak self] recognizedString in
                                DispatchQueue.main.async {
                                    tempArray.append(recognizedString)
                                    
                                    print(self?.ocrInstance.currentOCRRecognizedBlobs ?? "Recognized Blob is empty")
                                    
                                }
                            }
                        }
                        recognizedStringArray.append(tempArray)
                    }
                    self?.saveData.set(recognizedStringArray, forKey: "save")
                    self?.labelText2()
                    
                    
                } else {
                    return
                }
            }
        }
    }
    
    func labelText(){
        let r0: String!
        let r1: String!
        let r2: String!
        let r3: String!
        let r4: String!
        let r5: String!
        let r6: String!
        let r7: String!
        let r8: String!
        if saveData.object(forKey: "save0") != nil{
            r0 = saveData.object(forKey: "save0") as? String
        } else {
            r0 = "?"
        }
        if saveData.object(forKey: "save1") != nil{
            r1 = saveData.object(forKey: "save1") as? String
        } else {
            r1 = "?"
        }
        if saveData.object(forKey: "save2") != nil{
            r2 = saveData.object(forKey: "save2") as? String
        } else {
            r2 = "?"
        }
        if saveData.object(forKey: "save3") != nil{
            r3 = saveData.object(forKey: "save3") as? String
        } else {
            r3 = "?"
        }
        if saveData.object(forKey: "save4") != nil{
            r4 = saveData.object(forKey: "save4") as? String
        } else {
            r4 = "?"
        }
        if saveData.object(forKey: "save5") != nil{
            r5 = saveData.object(forKey: "save5") as? String
        } else {
            r5 = "?"
        }
        if saveData.object(forKey: "save6") != nil{
            r6 = saveData.object(forKey: "save6") as? String
        } else {
            r6 = "?"
        }
        if saveData.object(forKey: "save7") != nil{
            r7 = saveData.object(forKey: "save7") as? String
        } else {
            r7 = "?"
        }
        if saveData.object(forKey: "save8") != nil{
            r8 = saveData.object(forKey: "save8") as? String
        } else {
            r8 = "?"
        }
        label.text = String(r0! + "\n" + r1! + "\n" + r2! + "\n" + r3! + "\n" + r4! + "\n" + r5! + "\n" + r6! + "\n" + r7! + "\n" + r8!)
    }
    
    func labelText2(){
        let array = saveData.object(forKey: "save") as! [[String]]
        let r1 = array[0]
        let r2 = array[1]
        let r3 = array[2]
        let r4 = array[3]
        let r5 = array[4]
        let r6 = array[5]
        let r7 = array[6]
        let r8 = array[7]
        let r9 = array[8]
        
        var str: String = ""
        for a in r1{
            str += a
        }
        str += "\n"
        for a in r2{
            str += a
        }
        str += "\n"
        for a in r3{
            str += a
        }
        str += "\n"
        for a in r4{
            str += a
        }
        str += "\n"
        for a in r5{
            str += a
        }
        str += "\n"
        for a in r6{
            str += a
        }
        str += "\n"
        for a in r7{
            str += a
        }
        str += "\n"
        for a in r8{
            str += a
        }
        str += "\n"
        for a in r9{
            str += a
        }
        label.text = str
        
        
//        var displayText = ""
//        for y in array {
//            for x in y {
//                displayText += x
//            }
//            displayText += "\n"
//        }
//        
//        label.text = displayText
//        print(displayText)
        
//        var str: String = ""
//        for y in array{
//            for x in y{
//                str += array
//            }
//            str += "\n"
//        }
//        label.text = String(str)
        
//            String(stringInterpolation: array[0][0],array[0][1],array[0][2],array[0][3],array[0][4],array[0][5],array[0][6],array[0][7],array[0][8],"\n",array[1][0],array[1][1],array[1][2],array[1][3],array[1][4],array[1][5],array[1][6],array[1][7],array[1][8],"\n",array[2][0],array[2][1],array[2][2],array[2][3],array[2][4],array[2][5],array[2][6],array[2][7],array[2][8],"\n",array[3][0],array[3][1],array[3][2],array[3][3],array[3][4],array[3][5],array[3][6],array[3][7],array[3][8],"\n",array[4][0],array[4][1],array[4][2],array[4][3],array[4][4],array[4][5],array[4][6],array[4][7],array[4][8],"\n",array[5][0],array[5][1],array[5][2],array[5][3],array[5][4],array[5][5],array[5][6],array[5][7],array[5][8],"\n",array[6][0],array[6][1],array[6][2],array[6][3],array[6][4],array[6][5],array[6][6],array[6][7],array[6][8],"\n",array[7][0],array[7][1],array[7][2],array[7][3],array[7][4],array[7][5],array[7][6],array[7][7],array[7][8],"\n",array[8][0],array[8][1],array[8][2],array[8][3],array[8][4],array[8][5],array[8][6],array[8][7],array[8][8])
//        
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        do {
            try device!.lockForConfiguration()
            var zoomScale = CGFloat(slider.value * 10.0)
            let zoomFactor = device?.activeFormat.videoMaxZoomFactor
            
            if zoomScale < 1 {
                zoomScale = 1
            } else if zoomScale > zoomFactor! {
                zoomScale = zoomFactor!
            }
            
            device?.videoZoomFactor = zoomScale
            device?.unlockForConfiguration()
        } catch {
            print("captureDevice?.lockForConfiguration() denied")
        }
    }
}

extension ViewController {
    // MARK: AVFoundation
    fileprivate func configureCameraForUse () {
        self.stillImageOutput = AVCaptureStillImageOutput()
        let fullResolution = UIDevice.current.userInterfaceIdiom == .phone && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) < 568.0
        
        if fullResolution {
            self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        } else {
            self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        }
        
        self.captureSession.addOutput(self.stillImageOutput)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.prepareCaptureSession()
        }
    }
    
    private func prepareCaptureSession () {
        do {
            self.captureSession.addInput(try AVCaptureDeviceInput(device: self.device))
        } catch {
            print("AVCaptureDeviceInput Error")
        }
        
        // layer customization
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer?.frame.size = self.cameraView.frame.size
        previewLayer?.frame.origin = CGPoint.zero
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // device lock is important to grab data correctly from image
        do {
            try self.device?.lockForConfiguration()
            self.device?.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            self.device?.focusMode = .continuousAutoFocus
            self.device?.unlockForConfiguration()
        } catch {
            print("captureDevice?.lockForConfiguration() denied")
        }
        
        //Set initial Zoom scale
        do {
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            try device?.lockForConfiguration()
            
            let zoomScale: CGFloat = 2.5
            
            if zoomScale <= (device?.activeFormat.videoMaxZoomFactor)! {
                device?.videoZoomFactor = zoomScale
            }
            
            device?.unlockForConfiguration()
        } catch {
            print("captureDevice?.lockForConfiguration() denied")
        }
        
        DispatchQueue.main.async(execute: {
            self.cameraView.layer.addSublayer(previewLayer!)
            self.captureSession.startRunning()
        })
    }
    
    // MARK: Image Processing
    fileprivate func prepareImageForCrop (using image: UIImage, make81: Bool = false) -> [[UIImage]]{
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        let imageOrientation = image.imageOrientation
        let degree = image.detectOrientationDegree()
        let cropSize = CGSize(width: 400, height: 400) //viewFinderの大きさ?
        
        //Downscale
        let cgImage = image.cgImage!
        
        let width = cropSize.width
        let height = image.size.height / image.size.width * cropSize.width
        
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace
        let bitmapInfo = cgImage.bitmapInfo
        
        let context = CGContext(data: nil,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace!,
                                bitmapInfo: bitmapInfo.rawValue)
        
        context!.interpolationQuality = CGInterpolationQuality.none
        // Rotate the image context
        context?.rotate(by: degreesToRadians(degree));
        // Now, draw the rotated/scaled image into the context
        context?.scaleBy(x: -1.0, y: -1.0)
        
        //Crop
        switch imageOrientation {
        case .right, .rightMirrored:
            context?.draw(cgImage, in: CGRect(x: -height, y: 0, width: height, height: width))
        case .left, .leftMirrored:
            context?.draw(cgImage, in: CGRect(x: 0, y: -width, width: height, height: width))
        case .up, .upMirrored:
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        case .down, .downMirrored:
            context?.draw(cgImage, in: CGRect(x: -width, y: -height, width: width, height: height))
        }
        
        
        let calculatedFrame = CGRect(x: 0, y: CGFloat((height - cropSize.height)/2.0), width: cropSize.width, height: cropSize.height)
        let scaledCGImage = context?.makeImage()?.cropping(to: calculatedFrame)
        
        
        //        return UIImage(cgImage: scaledCGImage!)
        if make81 == true{
            return cropImage81(si: UIImage(cgImage: scaledCGImage!))
        }
//        return cropImage(si: UIImage(cgImage: scaledCGImage!), scgi: scaledCGImage!)
        return cropImage81(si: UIImage(cgImage: scaledCGImage!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 正方形のuiimage -> 横長の９つの[uiimage]
    func cropImage(si squareImage: UIImage, scgi squareCGImage: CGImage) -> [UIImage] {
        var resultIndex: [UIImage] = []
        let resizeSize = CGSize.init(width: squareCGImage.width , height: squareCGImage.height / 9)
        
        for n in 0...8 {
            
            let resizeSize = CGSize.init(width: squareImage.size.width, height: squareImage.size.height)
            UIGraphicsBeginImageContext(resizeSize)
            squareImage.draw(in: CGRect.init(x: 0, y: 0, width: squareImage.size.width, height: squareImage.size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 切り抜き処理
            let cropRect  = CGRect.init(x: 0, y: squareImage.size.height / 9 * CGFloat(n),
                                        width: squareImage.size.width, height: squareImage.size.height / 9)
            let cropRef   = resizeImage!.cgImage!.cropping(to: cropRect)
            let cropedUiImage = UIImage(cgImage: cropRef!)
            resultIndex.append(cropedUiImage)
        }
        return resultIndex
    }
    
    func cropImage81(si squareImage: UIImage) -> [[UIImage]]{
        var resultArray: [[UIImage]] = []
        let originSize = CGSize.init(width: squareImage.size.width, height: squareImage.size.height)
        let resizeSize = CGSize.init(width: originSize.width / 9, height: originSize.height / 9)
        for y in 0...8{
            var tempUiImageArray : [UIImage] = []
            for x in 0...8{
                UIGraphicsBeginImageContext(originSize)
                squareImage.draw(in: CGRect.init(x: 0, y: 0, width: originSize.width, height: originSize.height))
                guard let resizeImage = UIGraphicsGetImageFromCurrentImageContext() else {
                    return []
                }
                UIGraphicsEndImageContext()
                
                let cropRect = CGRect.init(x: resizeSize.width * CGFloat(x),
                                           y: resizeSize.width * CGFloat(y),
                                           width: resizeSize.width,
                                           height: resizeSize.height)
                let cropRef = resizeImage.cgImage!.cropping(to: cropRect)
                let croppedUIImage = UIImage(cgImage: cropRef!)
                tempUiImageArray.append(croppedUIImage)
            }
            resultArray.append(tempUiImageArray)
        }
        print(resultArray)
        return resultArray
    }
    
    
    
}

