//
//  HWPrinterAdapter.h
//  HelloCordova
//
//  Created by Alex on 2016-06-29.
//
//

#import "HWDeviceAdapter.h"


// @ public cordova interface

@interface HWPrinterAdapter : HWDeviceAdapter

- (void) printJob: (CDVInvokedUrlCommand *) cmd;
- (void) printerClose: (CDVInvokedUrlCommand *) cmd;
- (void) supportedFonts: (CDVInvokedUrlCommand *) cmd;
- (void) supportedBarcodes: (CDVInvokedUrlCommand *) cmd;
- (void) lineWidth: (CDVInvokedUrlCommand *) cmd;

@end
