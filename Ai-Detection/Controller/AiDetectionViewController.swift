//
//  AiDetectionViewController.swift
//  Ai-Detection
//
//  Created by Hiền Đẹp Trai on 01/12/2020.

import UIKit
import CoreML
import Vision
import MHLoadingButton

class AiDetectionViewController: UIViewController {

    private var videoCapture: VideoCapture!
    private let serialQueue = DispatchQueue(label: "co.jp.Ai-Detection.serialqueue")
    
    private let videoSize = CGSize(width: 1280, height: 720)
    private let preferredFps: Int32 = 2
    
    private var modelUrls: [URL]!
    private var selectedVNModel: VNCoreMLModel?
    private var selectedModel: MLModel?

    private var cropAndScaleOption: VNImageCropAndScaleOption = .scaleFit
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var bbView: BoundingBoxView!
    @IBOutlet weak var loadingCameraButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingCameraButton.indicator = BallPulseSyncIndicator(color: .white)
        self.loadingCameraButton.showLoader(userInteraction: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let videoCapture = videoCapture else {return}
        videoCapture.resizePreview()
        // TODO: Should be dynamically determined
        self.bbView.updateSize(for: CGSize(width: videoSize.height, height: videoSize.width))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let videoCapture = videoCapture else {return}
        videoCapture.stopCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startCamera() {
        
        let spec = VideoSpec(fps: self.preferredFps, size: self.videoSize)
        let frameInterval = 1.0 / Double(preferredFps)
//        DispatchQueue.main.async {
            self.videoCapture = VideoCapture(cameraType: .back,
                                             preferredSpec: spec,
                                             previewContainer: self.previewView.layer)
            
            self.videoCapture.imageBufferHandler = {[unowned self] (imageBuffer, timestamp, outputBuffer) in
                let delay = CACurrentMediaTime() - timestamp.seconds
                if delay > frameInterval {
                    return
                }
                self.serialQueue.async {
                    self.runModel(imageBuffer: imageBuffer)
                }
            }
            
            let modelPaths = Bundle.main.paths(forResourcesOfType: "mlmodel", inDirectory: "models")
            
            self.modelUrls = []
            for modelPath in modelPaths {
                let url = URL(fileURLWithPath: modelPath)
                let compiledUrl = try! MLModel.compileModel(at: url)
                self.modelUrls.append(compiledUrl)
            }
            
            self.selectModel(url: self.modelUrls.last!)
            self.videoCapture.startCapture()
//        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.loadingCameraButton.hideLoader()
        }
    }
    
    // MARK: - Private
    
    private func showActionSheet() {
        let alert = UIAlertController(title: "Models", message: "Choose a model", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        for modelUrl in modelUrls {
            let action = UIAlertAction(title: modelUrl.modelName, style: .default) { (action) in
                self.selectModel(url: modelUrl)
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func selectModel(url: URL) {
        selectedModel = try! MLModel(contentsOf: url)
        do {
            selectedVNModel = try VNCoreMLModel(for: selectedModel!)
            let nameModel = url.modelName.components(separatedBy: "_")
            self.modelNameLabel.text = nameModel[0]
        }
        catch {
            fatalError("Could not create VNCoreMLModel instance from \(url). error: \(error).")
        }
    }
    
    private func runModel(imageBuffer: CVPixelBuffer) {
        guard let model = selectedVNModel else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
        
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            if let results = request.results as? [VNClassificationObservation] {
                self.processClassificationObservations(results)
            } else if #available(iOS 12.0, *), let results = request.results as? [VNRecognizedObjectObservation] {
                self.processObjectDetectionObservations(results)
            }
        })
        
        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = cropAndScaleOption
        
        do {
            try handler.perform([request])
        } catch {
            print("failed to perform")
        }
    }

    @available(iOS 12.0, *)
    private func processObjectDetectionObservations(_ results: [VNRecognizedObjectObservation]) {
        bbView.observations = results
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bbView.isHidden = false
            self.bbView.setNeedsDisplay()
        }
    }

    private func processClassificationObservations(_ results: [VNClassificationObservation]) {
        DispatchQueue.main.async(execute: {
            self.bbView.isHidden = true
        })
    }

    @IBAction func changeAiDetectionButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Models", message: "Choose a model", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        for modelUrl in modelUrls {
            
            let action = UIAlertAction(title: modelUrl.modelName, style: .default) { (action) in
                self.selectModel(url: modelUrl)
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeCameraButtonTapped(_ sender: UIButton) {
    }
}

extension URL {
    var modelName: String {
        return lastPathComponent.replacingOccurrences(of: ".mlmodelc", with: "")
    }
}
