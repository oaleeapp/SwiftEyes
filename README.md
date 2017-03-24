# SwiftEyes

[![CI Status](http://img.shields.io/travis/oaleeapp/SwiftEyes.svg?style=flat)](https://travis-ci.org/oaleeapp/SwiftEyes)
[![Version](https://img.shields.io/cocoapods/v/SwiftEyes.svg?style=flat)](http://cocoapods.org/pods/SwiftEyes)
[![License](https://img.shields.io/cocoapods/l/SwiftEyes.svg?style=flat)](http://cocoapods.org/pods/SwiftEyes)
[![Platform](https://img.shields.io/cocoapods/p/SwiftEyes.svg?style=flat)](http://cocoapods.org/pods/SwiftEyes)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

> If this is first time you use [OpenCV-Dynamic](https://github.com/Legoless/OpenCV-Dynamic) as the dependency, it'll take time to install.


## How to Use

Just import the framework

`import SwiftEyes`

In class `SEMotionTrackViewController`, you can see the example.

Simply use the code below can identify the motion blob.

```Swift

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

```



## Videos

![motion tracking](http://i.giphy.com/kLL70o7Y9Y5Fe.gif)
![color tracking](http://i.giphy.com/3o6YgbtjjTUor5YDyo.gif)

[![motion tracking](https://img.youtube.com/vi/i3xDONms4u4/0.jpg)](https://youtu.be/i3xDONms4u4)
[![color tracking](https://img.youtube.com/vi/EDMr6cGkV0Y/0.jpg)](https://youtu.be/EDMr6cGkV0Y)



## Requirements

If you didn't install CocoaPods yet, you can install from [here](https://cocoapods.org/).

And before you run `pod install`, please be sure that you have install `cmake` as well.

To download it, simply use [Homebrew](https://brew.sh/) to install:

```ruby
brew install cmake
```

## Installation

SwiftEyes is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftEyes"
```

## Author

Victor Lee, specialvict@gmail.com

## License

BSD license, respect OpenCV license as well.
