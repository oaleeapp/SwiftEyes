//
//  ViewController.swift
//  SwiftEyes
//
//  Created by Victor Lee on 02/03/2017.
//  Copyright (c) 2017 Victor Lee. All rights reserved.
//

import UIKit
import SwiftEyes

class ViewController: UIViewController {

    let eyes = SwiftEyes()

    @IBOutlet weak var cameraImageView: UIImageView!

    @IBOutlet weak var displayImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        eyes.start(cameraImageView: cameraImageView, displayImageView: displayImageView)
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func viewDidDisappear(_ animated: Bool) {
        eyes.reset()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

