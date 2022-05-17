//
//  CameraREpository.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/15.
//

import AVFoundation
import RxSwift

protocol CameraRepository {
    func findCameraDevices() -> [AVCaptureDevice]
    func startCamera(config: CameraSession.Config, delegate: CameraSessionDelegate?) -> Single<Swift.Result<AVCaptureSession, CameraSessionError>>
    func captureBuffer() -> Single<Swift.Result<CMSampleBuffer, CameraSessionError>>
    func stopCamera()
}
