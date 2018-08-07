//
//  AddNewBarcodeViewController.swift
//  Shopper Shopper
//
//  Created by James Boric on 19/04/2016.
//  Copyright © 2016 Ode To Code. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class AddNewQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var lblDataInfo: UILabel!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var storeTextField: UITextField!
    
    @IBOutlet weak var discountTextField: UITextField!
    
    @IBOutlet weak var expDatePicker: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    let captureSession = AVCaptureSession()
    /// The device used as input for the capture session.
    var captureDevice:AVCaptureDevice?
    /// The UI layer to display the feed from the input source, in our case, the camera.
    var captureLayer:AVCaptureVideoPreviewLayer?
    
    var qrcodeImage: CIImage!
    
    var capLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgQRCode.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCaptureSession()
    }
    
    @IBAction func moveKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    fileprivate func setupCaptureSession(){
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let deviceInput:AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(deviceInput)){
            // Show live feed
            captureSession.addInput(deviceInput)
            self.setupPreviewLayer({
                self.captureSession.startRunning()
                self.addMetaDataCaptureOutToSession()
            })
        } else {
            self.showError("Error while setting up input captureSession.")
        }
    }
    
    /**
     Handles setting up the UI to show the camera feed.
     
     - parameter completion: Completion handler to invoke if setting up the feed was successful.
     */
    fileprivate func setupPreviewLayer(_ completion:() -> ()) {
        self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capLayer = self.captureLayer
        capLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        capLayer.frame = self.imgQRCode.frame
        mainScrollView.layer.addSublayer(capLayer)
        completion()
        
    }
    
    //MARK: Metadata capture
    /**
    Handles identifying what kind of data output we want from the session, in our case, metadata and the available types of metadata.
    */
    fileprivate func addMetaDataCaptureOutToSession()
    {
        let metadata = AVCaptureMetadataOutput()
        self.captureSession.addOutput(metadata)
        metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
        metadata.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
    
    //MARK: Delegate Methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for metadata in metadataObjects{
            
            if let decodedData:AVMetadataMachineReadableCodeObject = metadata as? AVMetadataMachineReadableCodeObject {
            
                
                lblDataInfo.text = decodedData.stringValue
                
                let data = decodedData.stringValue.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                
                
                
                let filter = CIFilter(name: "CIQRCodeGenerator")
                
                
                filter!.setValue(data, forKey: "inputMessage")
                filter!.setValue("L", forKey: "inputCorrectionLevel")
                
                let transformedImage = filter!.outputImage!.applying(CGAffineTransform(scaleX: imgQRCode.frame.size.width * 4 / filter!.outputImage!.extent.size.width, y: imgQRCode.frame.size.height * 4 / filter!.outputImage!.extent.size.height))
                
                let ciContext = CIContext()
                let cgImage = ciContext.createCGImage(transformedImage, from: transformedImage.extent)
                
                //imgQRCode.image = UIImage(CGImage: cgImage)
                
                //qrcodeImage =
                
                qrcodeImage = CIImage(cgImage: cgImage!)
                
                qrImage = UIImage(cgImage: cgImage!)
                
                displayQRCodeImage()
            }
            
            
            
            
        }
    }
    
    
    var qrImage = UIImage()
    
    func displayQRCodeImage() {
        /*let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height*/
        
        imgQRCode.image = qrImage
        
        captureSession.stopRunning()
        
        capLayer.removeFromSuperlayer()
    
    }
    
    
    //MARK: Utility Functions
    /**
    Shows any error that may occur via an alert view.
    
    - parameter error: The error message.
    */
    fileprivate func showError(_ error:String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let dismiss:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:{(alert:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let qr = qrImage
        let discount = discountTextField.text!
        let storeName = storeTextField.text!
        let expDate = expDatePicker.date
        
        
        let context = self.context
        
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
        
        newCard.setValue(qr, forKey: "barcode")
        newCard.setValue(discount, forKey: "discount")
        newCard.setValue(expDate, forKey: "expiryDate")
        newCard.setValue(storeName, forKey: "store")
        
        do {
            try context.save()
        }
            
        catch {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        
        performSegue(withIdentifier: "backFromQR", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQR" {
            let thing = segue.destination as! UITabBarController
            thing.selectedIndex = 1
        }
    }
    
    
}
























