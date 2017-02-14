//
//  SEColorTrackViewController.swift
//  SwiftEyes
//
//  Created by lee on 12/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftEyes


class SEColorTrackViewController: UIViewController {

    struct HSVThreshold {
        var hMin: Int;
        var hMax: Int;
        var sMin: Int;
        var sMax: Int;
        var vMin: Int;
        var vMax: Int;
    }


    let eyes = SwiftEyes()
    var threshold: HSVThreshold {
        get{
            let threshold = HSVThreshold(
                hMin: Int(self.hMinSlider.value * 255),
                hMax: Int(self.hMaxSlider.value * 255),
                sMin: Int(self.sMinSlider.value * 255),
                sMax: Int(self.sMaxSlider.value * 255),
                vMin: Int(self.vMinSlider.value * 255),
                vMax: Int(self.vMaxSlider.value * 255))

            return threshold
        }
    }

    @IBOutlet weak var displayImageView: UIImageView!

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var hMinSlider: UISlider!

    @IBOutlet weak var hMaxSlider: UISlider!

    @IBOutlet weak var sMinSlider: UISlider!

    @IBOutlet weak var sMaxSlider: UISlider!

    @IBOutlet weak var vMinSlider: UISlider!

    @IBOutlet weak var vMaxSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eyes.start(displayImageView: displayImageView, andFilterImage: filterImageView)
        eyes.setThreshold(hMin: threshold.hMin, hMax: threshold.hMax, sMin: threshold.sMin, sMax: threshold.sMax, vMin: threshold.vMin, vMax: threshold.vMax)
        
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        eyes.reset()
    }

    @IBAction func changeHSVThresholdBy(_ sender: UISlider) {


        print(threshold)
        eyes.setThreshold(hMin: threshold.hMin, hMax: threshold.hMax, sMin: threshold.sMin, sMax: threshold.sMax, vMin: threshold.vMin, vMax: threshold.vMax)

    }


}
