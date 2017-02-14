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

    public func start(displayImageView: UIImageView,andFilterImage filterImageView: UIImageView) {

        cvWrapper = CVWrapper()
        cvWrapper?.startDisplay(displayImageView, andFilterImageView: filterImageView)

    }

    public func setThreshold(hMin: Int, hMax: Int, sMin: Int, sMax: Int, vMin: Int, vMax:Int) {
        cvWrapper?.setHMin(Int32(hMin), andHMax: Int32(hMax), andSMin: Int32(sMin), andSMax: Int32(sMax), andVMin: Int32(vMin), andVMax: Int32(vMax))
    }

    public func reset() {
        cvWrapper?.reset()
    }


    // 透過SwiftEyes可以拿到CameraFeed
    // 成為SwiftEyes的
    // 對，我必須要讓Swift可以存取OpenCV的Function
    // 要透過SwiftEyes存取嗎？ 還是透過其他的Class?
    // 能夠讓使用Swift開發的人可以輕易的使用基本功能
    // 可以使用Mat
    // 可以開Camera
    
    
}
