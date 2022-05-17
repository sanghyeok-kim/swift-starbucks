//
//  CameraSession.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/15.
//

import AVFoundation
import CoreImage

protocol CameraSessionDelegate: AnyObject {
    func cameraCaptureOutput(didOutput sampleBuffer: CMSampleBuffer)
}

class CameraSession: NSObject {
    
    class Config {
        var preset: AVCaptureSession.Preset = .hd1280x720
        var queue = DispatchQueue(label: "com.cameraSession.lockQueue")
        var formatType: OSType = kCVPixelFormatType_32BGRA
        var cameraType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera
        var position: AVCaptureDevice.Position = .back
    }
    
    weak var delegate: CameraSessionDelegate?
    
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var config = Config()
    private var currentBuffer: CMSampleBuffer?
    
    func findCameraDevices(_ types: [AVCaptureDevice.DeviceType], position: AVCaptureDevice.Position) -> [AVCaptureDevice] {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: types,
            mediaType: .video,
            position: position
        )
        
        return deviceDiscoverySession.devices
    }
    
    func startCamera(config: Config) -> AVCaptureSession? {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
        captureSession.beginConfiguration()
        
        let newCameraDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [config.cameraType], mediaType: .video, position: config.position).devices.first
        
        guard let cameraDevice = newCameraDevice,
              let videoInput = try? AVCaptureDeviceInput(device: cameraDevice) else {
            return nil
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        videoDataOutput.setSampleBufferDelegate(self, queue: config.queue)
        videoDataOutput.alwaysDiscardsLateVideoFrames = false
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: config.formatType] as [String: Any]
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
        
        return captureSession
    }
    
    func captureBuffer() -> CMSampleBuffer? {
        guard let buffer = currentBuffer else {
            return nil
        }
        
        return buffer
    }
    
    func stopSession() {
        captureSession.stopRunning()
    }
}

extension CameraSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        currentBuffer = sampleBuffer
        delegate?.cameraCaptureOutput(didOutput: sampleBuffer)
    }
}
