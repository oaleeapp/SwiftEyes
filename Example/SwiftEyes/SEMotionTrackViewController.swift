//
//  SEMotionTrackViewController.swift
//  SwiftEyes
//
//  Created by lee on 01/03/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftEyes
import AVFoundation

class SEMotionTrackViewController: UIViewController, OCVVideoCameraDelegate {
    var cameraParentImageView = UIImageView()
    var currentMat: OCVMat?
    var previousMat: OCVMat?


    @IBOutlet weak var cameraImageView: UIImageView!


    @IBOutlet weak var displayImageView: UIImageView!
    var videoCamera: OCVVideoCamera?;

    override func viewDidLoad() {
        super.viewDidLoad()

        videoCamera = OCVVideoCamera(parentView: cameraParentImageView)
        videoCamera?.delegate = self
        videoCamera?.defaultAVCaptureDevicePosition = .front;
        videoCamera?.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
        videoCamera?.defaultAVCaptureVideoOrientation = .portrait;
        videoCamera?.defaultFPS = 20;
        videoCamera?.start()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func processImage(_ image: OCVMat!) {

        // Parameters
        let blurSize = 10
        let sensitivityValue = 20.0
        var differenceMat = OCVMat(cgSize: CGSize(width: image.size.width, height: image.size.height), type: image.type, channels: image.channels)


        // from BGR to RGB
        OCVOperation.convertColor(fromSource: image, toDestination: image, with: .typeBGRA2RGBA)

        // set current mat
        currentMat = image.clone()

        // convert current mat from RGB to GrayScale
        OCVOperation.convertColor(fromSource: currentMat, toDestination: currentMat, with: .typeRGBA2GRAY)

        if previousMat != nil {
            OCVOperation.absoluteDifference(onFirstSource: currentMat, andSecondSource: previousMat, toDestination: differenceMat)
            OCVOperation.blur(onSource: differenceMat, toDestination: differenceMat, with: OCVSize(width: blurSize, height: blurSize))
            OCVOperation.threshold(onSource: differenceMat, toDestination: differenceMat, withThresh: sensitivityValue, withMaxValue: 255.0, with: .binary)
        }

        DispatchQueue.main.sync {
            cameraImageView.image = image.image()
            displayImageView.image = differenceMat.image()
        }

        // use previous mat(frame) to compare with next mat(frame)
        previousMat = currentMat

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
