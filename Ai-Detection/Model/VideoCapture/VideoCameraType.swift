//
//  VideoCameraType.swift
//  Ai-Detection
//
//  Created by Hiền Đẹp Trai on 02/12/2020.
//

import AVFoundation

enum CameraType : Int {
    case back
    case front
    
    func captureDevice() -> AVCaptureDevice {
        switch self {
        case .front:
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices
            print("devices:\(devices)")
            for device in devices where device.position == .front {
                return device
            }
        default:
            break
        }
        return AVCaptureDevice.default(for: .video)!
    }
}
