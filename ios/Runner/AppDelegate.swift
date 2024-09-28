import UIKit
import Photos
import Flutter
import FBSDKShareKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller :FlutterViewController = window?.rootViewController as! FlutterViewController
        let imageSavingChannel = FlutterMethodChannel(name: "save_file", binaryMessenger: controller.binaryMessenger)
        
        imageSavingChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall,result: @escaping FlutterResult)-> Void in
            
            
            switch call.method {
             
              case "saveImageToGallery":
                  if let arguments = call.arguments as? [String: Any],
                     let imageData = arguments["imageData"] as? FlutterStandardTypedData {
                      self?.saveImageToGallery(imageData: imageData.data) { success, error in
                          if success {
                              result(true)
                          } else {
                              result(FlutterError(code: "SAVE_FAILED", message: "Failed to save image to gallery", details: nil))
                          }
                      }
                  } else {
                      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments provided", details: nil))
                  }
                case "savePdfToFiles":
                  if let arguments = call.arguments as? [String: Any],
                     let imageData = arguments["fileData"] as? FlutterStandardTypedData {
                      self?.savePdfToFiles(fileData: imageData.data) { success, error in
                          if success {
                              result(true)
                          } else {
                              result(FlutterError(code: "SAVE_FAILED", message: "Failed to save image to gallery", details: nil))
                          }
                      }
                  } else {
                      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments provided", details: nil))
                  }



              default:
                  result(FlutterMethodNotImplemented)
              }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    
   
    public func saveImageToGallery(imageData: Data, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges {
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            options.shouldMoveFile = true
            creationRequest.addResource(with: .photo, data: imageData, options: options)
        } completionHandler: { success, error in
            completion(success, error)
        }
    }
    public func savePdfToFiles(pdfData: Data, completion: @escaping (Bool, Error?) -> Void) {
    let fileManager = FileManager.default
    let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

    let timestamp = Int(Date().timeIntervalSince1970 * 1000)

    let pdfFilePath = documentDirectory.appendingPathComponent("\(timestamp).pdf")
    
    do {
        try pdfData.write(to: pdfFilePath)
        completion(true, nil)
    } catch let error {
        completion(false, error)
    }
}
   

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject {
            
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                //   let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                //   alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //   self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    
}
