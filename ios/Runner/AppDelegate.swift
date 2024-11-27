import Flutter
import UIKit
import AVFoundation

//@main
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var cameraHandler: CameraHandler!

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let cameraChannel = FlutterMethodChannel(name: "camera_channel", binaryMessenger: controller.binaryMessenger)
    
    cameraHandler = CameraHandler(methodChannel: cameraChannel)
    
    cameraChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "setZoomLevel":
        if let args = call.arguments as? [String: Any], let zoom = args["zoom"] as? CGFloat {
          self?.cameraHandler.setZoomLevel(zoom)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
