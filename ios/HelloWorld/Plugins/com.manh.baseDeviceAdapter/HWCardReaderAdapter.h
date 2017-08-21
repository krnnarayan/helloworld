//
//  HWCashDrawerAdapter.h
//  HelloCordova
//
//  Created by Alex on 2016-06-28.
//
//

#import "HWDeviceAdapter.h"

// @ public cordova interface

@interface HWCardReaderAdapter : HWDeviceAdapter

-(void) hasPinpad: (CDVInvokedUrlCommand *) cmd;
-(void) enablePinpad: (CDVInvokedUrlCommand *) cmd;
-(void) disablePinpad: (CDVInvokedUrlCommand *) cmd;
-(void) requestPinEntry: (CDVInvokedUrlCommand *) cmd;
-(void) requestCardEntry: (CDVInvokedUrlCommand *) cmd;
-(void) requestTextEntry: (CDVInvokedUrlCommand *) cmd;
-(void) cancelOperation: (CDVInvokedUrlCommand *) cmd;

@end
