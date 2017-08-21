//
//  HWCashDrawerAdapter.m
//  HelloCordova
//
//  Created by Alex on 2016-06-28.
//
//

#import "HWCardReaderAdapter.h"

@implementation HWCardReaderAdapter

-(const NSString *) getDeviceType{
    return kDeviceAdapterType_CardReader;
}


-(void) hasPinpad: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) enablePinpad: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) disablePinpad: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) requestPinEntry: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) requestCardEntry: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) requestTextEntry: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) cancelOperation: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}


@end
