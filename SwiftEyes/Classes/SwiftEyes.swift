//
//  SwiftEyes.swift
//  SwiftEyes
//
//  Created by lee on 02/02/2017.
//  Copyright © 2017 swiftwithme. All rights reserved.
//

import UIKit

public class SwiftEyes: NSObject {

    var cvWrapper: CVWrapper?

    public func start(cameraImageView: UIImageView, displayImageView: UIImageView) {

        cvWrapper = CVWrapper()
        cvWrapper?.startCameraImageView(cameraImageView, andDisplay: displayImageView)

    }
}
