//
//  HWBarcodeScannerAdapter.h
//  HelloCordova
//
//  Created by Alex on 2016-06-28.
//
//

#import "HWDeviceAdapter.h"

// @ public cordova interface

@interface HWBarcodeScannerAdapter : HWDeviceAdapter

-(void) getSupportedBarcodes: (CDVInvokedUrlCommand *) cmd;
-(void) enableBarcode: (CDVInvokedUrlCommand *) cmd;
-(void) disableBarcode:(CDVInvokedUrlCommand *) cmd;
-(void) startRead:(CDVInvokedUrlCommand *) cmd;
-(void) stopRead:(CDVInvokedUrlCommand *) cmd;

@end


