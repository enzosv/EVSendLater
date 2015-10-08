# EVSendLater

[![Version](https://img.shields.io/cocoapods/v/EVSendLater.svg?style=flat)](http://cocoapods.org/pods/EVSendLater)
[![License](https://img.shields.io/cocoapods/l/EVSendLater.svg?style=flat)](http://cocoapods.org/pods/EVSendLater)
[![Platform](https://img.shields.io/cocoapods/p/EVSendLater.svg?style=flat)](http://cocoapods.org/pods/EVSendLater)

## Description

Allow your app to silently handle failed HTTP requests due to internet connectivity issues and stop bugging your users about sending again and again.


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Saving
When a POST request fails to send due to internet issues or other errors you may wish to handle, save its parameters using 
```swift
EVSendLater.sharedManager.saveForLater(url, params: params)
```

This will save the parameters to an NSDictionary which you must persist using
```swift
EVSendLater.sharedManager.synchronizeSaves()
// (similar to NSUserDefaults)
```
*Ideally, this should only be called before the app exits*
*In order to automatically save every change, use `EVSendLater.sharedManager.saveImmediately = true`*
#### Example
```swift
Alamofire.request(.POST, url, parameters: params).responseJSON { (request, response, result) -> Void in
    if result.isFailure{
        EVSendLater.sharedManager.saveForLater(url, params: params)
        EVSendLater.sharedManager.synchronizeSaves()
    }
}
```
*note: Not all failures should be saved for later. If you only wish to persist requests sent offline, please use [Reachability](https://github.com/tonymillion/Reachability) or something similar*

### Retrieving
In order to retrieve this to reattempt sending, use
```swift
EVSendLater.sharedManager.getSavesForUrl(url, delete: true)
```
The delete parameter will assume that the POSTS will go through. Simply handle their errors again using `EVSendLater.sharedManager.saveForLater(url, params: params)`

#### Example for single URL
```swift
if let params = EVSendLater.sharedManager.getSavesForUrl(url, delete:true){
    for p in params{
        Alamofire.request(.POST, u, parameters: p).responseJSON { (request, response, result) -> Void in
            if result.isFailure{
                EVSendLater.sharedManager.saveForLater(url, params: p)
            }
            EVSendLater.sharedManager.synchronizeSaves()
        }
    }
}
```

You can also go through all urls to send everything using
```swift
EVSendLater.sharedManager.getAllSaves(true)
```
The delete parameter will assume that the POSTS will go through. Simply handle their errors again using `EVSendLater.sharedManager.saveForLater(url, params: params)`

#### Example for all URLs
```swift
for (url, parameters) in EVSendLater.sharedManager.getAllSaves(true){
    if let u = url as? String{
        if let params = parameters as? [[String: AnyObject]]{
            for p in params{
                Alamofire.request(.POST, u, parameters: p).responseJSON { (request, response, result) -> Void in
                    if result.isFailure{
                        EVSendLater.sharedManager.saveForLater(u, params: p)
                    }
                    EVSendLater.sharedManager.synchronizeSaves()
                }
            }
        }
    }
}
```

## Installation

EVSendLater is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EVSendLater"
```

## Author

Enzo Vergara, vergara.enzo@gmail.com

## License

EVSendLater is available under the MIT license.

Copyright (c) 2015 Enzo Vergara <vergara.enzo@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Acknowledgement
Example was created using [Alamofire](https://github.com/Alamofire/Alamofire)

Originally created for use with [Booky -Manila Restaurants](http://ph.phonebooky.com)
