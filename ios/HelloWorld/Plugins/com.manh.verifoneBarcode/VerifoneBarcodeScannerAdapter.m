//
//  VerifoneBarcodeScannerAdapter.m
//  HelloCordova
//
//  Created by Alex on 2016-06-29.
//
//

#import "VerifoneBarcodeScannerAdapter.h"
#import "VFBarcode.h"
#import <VMF/VMFramework.h>

NSString * kDeviceAdapterName_VFIBarcodeScanner     = @"VeriFone Barcode Scanner";


@implementation VerifoneBarcodeScannerAdapter

//@synthesize barcode;
@synthesize isInitialized;


- (id)init {
    
    self = [super init];
//    if(self) {
//        isInitialized = NO;
//    }
    
//    [self initializeOnBackgroundThread];
    //[self performSelectorInBackground:@selector(initializeOnBackgroundThread) withObject:nil];
    return self;
}

- (void)pluginInitialize{
    [super pluginInitialize];
    isInitialized = NO;
    [self initializeOnBackgroundThread];
}


- (void) initializeOnBackgroundThread {
    
    [[VFBarcode barcode] setDelegate:self];
    [[VFBarcode barcode] initDevice];
    [[VFBarcode barcode] setScanner1D];
    [[VFBarcode barcode] setEdge];
    
}



-(void) deviceInfo: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                         messageAsDictionary:   @{@"device"     : kDeviceAdapterName_VFIBarcodeScanner,
                                                                  @"type"       : kDeviceAdapterType_BarcodeScanner,
                                                                  @"vendor"     : @"VeriFone Inc",
                                                                  @"vendor-sdk" : @"VMF.Framework",
                                                                  @"platform"   : @"iOS",
                                                                  @"plugin-ver" : @"0.0.1",
                                                                  @"status"     : @(self.deviceIsDisabled? DeviceStatusCode_DISABLED : DeviceStatusCode_READY),
                                                                  @"serial-no"  : @"0000-0000"
                                                                  }
                            ];
    
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
    
}

-(void) deviceStatus: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                         messageAsDictionary: self.deviceIsDisabled?@{@"status"      : @(DeviceStatusCode_DISABLED),
                                                                                      @"description" : @"Device is disabled"} :
                            
                            @{@"status"      : @(DeviceStatusCode_READY),
                              @"description" : @"Device is ready"}
                            ];
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
}

-(void) enableDevice: (CDVInvokedUrlCommand *) cmd{
    self.deviceIsDisabled  = NO;
    [self returnSuccess: cmd.callbackId];
}

-(void) disableDevice: (CDVInvokedUrlCommand *) cmd{
    self.deviceIsDisabled  = YES;
    [self returnSuccess: cmd.callbackId];
}

-(BOOL) initializeWithParameters: (CDVInvokedUrlCommand *) cmd{
    [self returnSuccess: cmd.callbackId];
    return  true;
}

//============================================


-(void) getSupportedBarcodes: (CDVInvokedUrlCommand *) cmd {
    
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                              messageAsArray: @[@"BC_EAN_UPC2" ,
                                                                @"BC_EAN_UPC1" ,
                                                                @"BC_CODABAR",
                                                                @"BC_CODABLOCK",
                                                                @"BC_CODE11",
                                                                @"BC_CODE39",
                                                                @"BC_CODE93",
                                                                @"BC_CODE128",
                                                                @"BC_DATAMATRIX",
                                                                @"BC_GS1",
                                                                @"BC_INTERLEAVED_2_OF_5",
                                                                @"BC_MAXICODE",
                                                                @"BC_MSICODE",
                                                                @"BC_PDF417",
                                                                @"BC_PLESSYCODE",
                                                                @"BC_QRCODE",
                                                                @"BC_STAN_2_OF_5_2BARS",
                                                                @"BC_STAN_2_OF_5_3BARS",
                                                                @"BC_TELEPEN" ]];
    
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
}

-(void) enableBarcode: (CDVInvokedUrlCommand *)  cmd{
    // This function meant to enable a barcode type which is supported by a scanner but not turned as on by default
    // The argument should be a barcode ID from the list returnded  by getSupportedBarcodes
    
    // SCAN Simulation
//     NSString * code = [cmd.arguments firstObject];
//     [self sendNotificationWithoutEventListeners: @"barcode-scanned" arguments: code];
    
       [[VFBarcode barcode] includeAllBarcodeTypes];
       [self returnSuccess: cmd.callbackId];
}


-(void) disableBarcode:(CDVInvokedUrlCommand *)  cmd{
    //
    // This is the opposite to enableBarcode method above
    //
    
    [self returnSuccess: cmd.callbackId];
}


-(void) startRead:(CDVInvokedUrlCommand *)  cmd{
    
    [[VFBarcode barcode] setSingleScan];
    [[VFBarcode barcode] startScan];
    [[VFBarcode barcode] beepOnParsedScan:TRUE];
    [[VFBarcode barcode] barcodeTypeEnabled:YES];
    
   // self.currentCallbackID = [[NSString alloc]initWithString:cmd.callbackId];
    [self returnSuccess: cmd.callbackId];
}

-(void) stopRead:(CDVInvokedUrlCommand *)  cmd{
    
    [[VFBarcode barcode] abortScan];
    
    [self returnSuccess: cmd.callbackId];
}

- (void) barcodeInitialize
{
    [[VFBarcode barcode] setScanner2D];
    [[VFBarcode barcode] setScanTimeout:5000];
    [[VFBarcode barcode] includeAllBarcodeTypes];
    [[VFBarcode barcode] barcodeTypeEnabled:YES];
}

-(void) scannerReconnected:(CDVInvokedUrlCommand *) cmd{
    NSLog(@"cmd.callbackId %@",cmd.callbackId);
    self.barcodeScannerRestartCallbackID = [[NSString alloc]initWithString:cmd.callbackId];
}

#pragma mark VF Delegate
#pragma mark ==


- (void)barcodeScanData:(NSData *)data barcodeType:(int)thetype {
    
    NSString* barcodeActual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *barcode = [[barcodeActual componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSLog(@"Data: %@ and Type: %d",barcode,thetype);
    
    [self sendNotificationWithoutEventListeners:@"barcode-scanned" arguments: barcode];
}


- (void) barcodeReconnectFinished {
    NSLog(@"Barcode Scanner ReconnectFinished. cmd.callbackId %@",self.barcodeScannerRestartCallbackID);
    [self sendNotificationWithCallbackId:self.barcodeScannerRestartCallbackID arguments:nil];
    
}

@end
