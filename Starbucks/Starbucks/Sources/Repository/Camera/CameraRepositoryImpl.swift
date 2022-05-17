//
//  CameraRepositoryImpl.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/15.
//

import AVFoundation
import RxSwift

class CameraRepositoryImpl: CameraRepository {
    private let cameraSession = CameraSession()
    private let captureOutput: () -> Void = {  }
    
    func findCameraDevices() -> [AVCaptureDevice] {
        
        cameraSession.findCameraDevices([.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera], position: .unspecified)
    }
    
    func startCamera(config: CameraSession.Config, delegate: CameraSessionDelegate? = nil) -> Single<Swift.Result<AVCaptureSession, CameraSessionError>> {
        Single.create { [weak self] observer in
            guard let session = self?.cameraSession.startCamera(config: config) else {
                observer(.success(.failure(.unowned)))
                return Disposables.create { }
            }
            self?.cameraSession.delegate = delegate
            observer(.success(.success(session)))
            return Disposables.create { }
        }
    }
    
    func captureBuffer() -> Single<Result<CMSampleBuffer, CameraSessionError>> {
        Single.create { [weak self] observer in
            guard let buffer = self?.cameraSession.captureBuffer() else {
                return Disposables.create { }
            }
            observer(.success(.success(buffer)))
            return Disposables.create { }
        }
    }
    
    func stopCamera() {
        cameraSession.stopSession()
    }
}
