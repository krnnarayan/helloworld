//
//  HWPrinterAdapter.m
//  HelloCordova
//
//  Created by Alex on 2016-06-29.
//
//


#import "HWPrinterAdapter.h"

@implementation HWPrinterAdapter

-(const NSString *) getDeviceType{
    return kDeviceAdapterType_Printer;
}

- (void) printJob: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

- (void) printerClose: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

- (void) supportedFonts: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

- (void) supportedBarcodes: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

- (void) lineWidth: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}



@end
