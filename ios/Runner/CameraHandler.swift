import AVFoundation
import Flutter

class CameraHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
  private var captureSession: AVCaptureSession!
  private var videoOutput: AVCaptureVideoDataOutput!
  private var assetWriter: AVAssetWriter!
  private var assetWriterInput: AVAssetWriterInput!
  private var methodChannel: FlutterMethodChannel!

  init(methodChannel: FlutterMethodChannel) {
    super.init()
    self.methodChannel = methodChannel
    setupCamera()
  }

  private func setupCamera() {
    captureSession = AVCaptureSession()
    guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
    
    do {
      let videoInput = try AVCaptureDeviceInput(device: videoDevice)
      if captureSession.canAddInput(videoInput) {
        captureSession.addInput(videoInput)
      }

      videoOutput = AVCaptureVideoDataOutput()
      videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
      if captureSession.canAddOutput(videoOutput) {
        captureSession.addOutput(videoOutput)
      }

      setupAssetWriter()
      captureSession.startRunning()
    } catch {
      print("Error setting up camera: \(error)")
    }
  }

  private func setupAssetWriter() {
    let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.mov")
    assetWriter = try? AVAssetWriter(outputURL: outputURL, fileType: .mov)

    let videoSettings: [String: Any] = [
      AVVideoCodecKey: AVVideoCodecType.hevc,
      AVVideoWidthKey: 1920,
      AVVideoHeightKey: 1080
    ]
    
    assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
    if assetWriter.canAdd(assetWriterInput) {
      assetWriter.add(assetWriterInput)
    }
  }

  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let assetWriter = assetWriter, assetWriter.status == .writing else { return }

    if assetWriterInput.isReadyForMoreMediaData {
      assetWriterInput.append(sampleBuffer)
    }

    if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
      let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
      // Send timestamp and frame data to Flutter
      // You can use methodChannel.invokeMethod to send data
    }
  }

  func setZoomLevel(_ zoom: CGFloat) {
    guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
    do {
      try videoDevice.lockForConfiguration()
      videoDevice.videoZoomFactor = max(1.0, min(zoom, videoDevice.activeFormat.videoMaxZoomFactor))
      videoDevice.unlockForConfiguration()
    } catch {
      print("Error setting zoom level: \(error)")
    }
  }
}
