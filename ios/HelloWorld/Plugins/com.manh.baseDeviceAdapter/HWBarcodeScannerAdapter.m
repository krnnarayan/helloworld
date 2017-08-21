//
//  HWBarcodeScannerAdapter.m
//  HelloCordova
//
//  Created by Alex on 2016-06-28.
//
//

#import "HWBarcodeScannerAdapter.h"

@implementation HWBarcodeScannerAdapter


-(const NSString *) getDeviceType{
    return kDeviceAdapterType_BarcodeScanner;
}

-(void) getSupportedBarcodes: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}

-(void) enableBarcode: (CDVInvokedUrlCommand *)  cmd{
    [self abstractMethodError: cmd];
}

-(void) disableBarcode:(CDVInvokedUrlCommand *)  cmd{
    [self abstractMethodError: cmd];
}

-(void) startRead:(CDVInvokedUrlCommand *)  cmd{
    [self abstractMethodError: cmd];
}

-(void) stopRead:(CDVInvokedUrlCommand *)  cmd{
    [self abstractMethodError: cmd];
}


@end
