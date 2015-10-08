# EVSendLater

[![CI Status](http://img.shields.io/travis/Enzo Vergara/EVSendLater.svg?style=flat)](https://travis-ci.org/Enzo Vergara/EVSendLater)
[![Version](https://img.shields.io/cocoapods/v/EVSendLater.svg?style=flat)](http://cocoapods.org/pods/EVSendLater)
[![License](https://img.shields.io/cocoapods/l/EVSendLater.svg?style=flat)](http://cocoapods.org/pods/EVSendLater)
[![Platform](https://img.shields.io/cocoapods/p/EVSendLater.svg?style=flat)](http://cocoapods.org/pods/EVSendLater)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

When a POST request fails to send due to internet issues or other errors you may wish to handle, save its parameters using EVSendLater.sharedManager.saveForLater(url, params: params)

This will save the parameters to an NSDictionary which you must persist using
`EVSendLater.sharedManager.synchronizeSaves() //(similar to NSUserDefaults)`

In order to retrieve this to reattempt sending, use
`EVSendLater.sharedManager.getSavesForUrl(url, delete: true)`
The delete parameter will assume that the POSTS will go through. Simply handle their errors again using EVSendLater.sharedManager.saveForLater(url, params: params)

You can also go through all urls to send everything using
`EVSendLater.sharedManager.getAllSaves()`
Just use EVSendLater.sharedManager.getSavesForUrl(url, delete: true) for each url

## Installation

EVSendLater is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EVSendLater"
```

## Author

Enzo Vergara, vergara.enzo@gmail.com

## License

EVSendLater is available under the MIT license. See the LICENSE file for more info.
