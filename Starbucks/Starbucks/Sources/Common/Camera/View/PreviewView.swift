//
//  PreviewView.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/16.
//

import AVFoundation
import UIKit

class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        layer as? AVCaptureVideoPreviewLayer
    }
}
