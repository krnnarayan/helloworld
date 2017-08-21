//
//  EpsonT88VPrinter.m
//  EpsonT88VPrinter
//
//  Created by Alex on 2016-10-14.
//  Copyright (c) 2016 Alex Strakholis. All rights reserved.
//

#import "EpsonT88VPrinterAdapter.h"

NSString * kDeviceAdapterName_EpsonT88VPrinter = @"EpsonT88V Printer";

@implementation EpsonT88VPrinterAdapter


-(void) deviceInfo: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                         messageAsDictionary:   @{@"device"     : kDeviceAdapterName_EpsonT88VPrinter,
                                                                  @"type"       : kDeviceAdapterType_Printer,
                                                                  @"vendor"     : @"Epson",
                                                                  @"vendor-sdk" : @"ePOS_SDK_iOS_2.3.0",
                                                                  @"platform"   : @"iOS",
                                                                  @"plugin-ver" : @"0.0.1",
                                                                  @"status"     : @(self.deviceIsDisabled? DeviceStatusCode_DISABLED : DeviceStatusCode_READY),
                                                                  @"serial-no"  : @"0000-0000"
                                                                  }
                            ];
    
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
    
}

- (void)pluginInitialize{
    [super pluginInitialize];
 }

-(BOOL) initializeWithParameters: (CDVInvokedUrlCommand *) cmd{

    self.fontList   = @[@"FONT_A",
                        @"FONT_B",
                        @"FONT_C",
                        @"FONT_D",
                        @"FONT_E"
                        ];
    
    self.barcodeList= @[
                        @"BARCODE_UPC_A",
                        @"BARCODE_UPC_E",
                        @"BARCODE_EAN13",
                        @"BARCODE_JAN13",
                        @"BARCODE_EAN8",
                        @"BARCODE_JAN8",
                        @"BARCODE_CODE39",
                        @"BARCODE_ITF",
                        @"BARCODE_CODABAR",
                        @"BARCODE_CODE93",
                        @"BARCODE_CODE128",
                        @"BARCODE_GS1_128",
                        @"BARCODE_GS1_DATABAR_OMNIDIRECTIONAL",
                        @"BARCODE_GS1_DATABAR_TRUNCATED",
                        @"BARCODE_GS1_DATABAR_LIMITED",
                        @"BARCODE_GS1_DATABAR_EXPANDED"
                        ];
    
    self.cmdMap = @{
               @"FONT"          : @"setTextFont:",
               @"FONTSIZE"      : @"setTextSize:",
               @"ALIGN"         : @"setTextAlign:",
               @"LINE_SPACING"  : @"setLineSpacing:",
               @"PRINT"         : @"printText:",
               @"LANGUAGE"      : @"setLangiage:",
               @"STYLE"         : @"setTextStyle:",
               @"LINE_FEED"     : @"printLineFeed:",
               @"PRINT_IMAGE"   : @"printImage:",
               @"PRINT_BARCODE" : @"printBarcode:",
               @"START_PAGE"    : @"startPage:",
               @"END_PAGE"      : @"endPage:",
               @"CUT_PAPER"     : @"cutPaper:",
               
               };

    
    self.target     = [@"TCP:" stringByAppendingString: cmd.arguments[0]];
    self.series     = EPOS2_TM_T88;
    self.language   = EPOS2_MODEL_ANK;
    
    if([cmd.arguments count] >= 3){
        self.series     = [cmd.arguments[1] intValue];
        self.language   = [cmd.arguments[2] intValue];
    }

    self.printer = [[Epos2Printer alloc] initWithPrinterSeries: self.series lang: self.language];
    
    [self returnSuccess: cmd.callbackId];

    return  true;
}



- (void) printerClose: (CDVInvokedUrlCommand *) cmd{
    //Empty method
}


- (void) supportedFonts: (CDVInvokedUrlCommand *) cmd{
    //[self abstractMethodError: cmd];ret
    
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                         messageAsArray: self.fontList];

    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];

}


- (void) supportedBarcodes: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                              messageAsArray: self.barcodeList];
    
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
}


- (void) lineWidth: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                              messageAsInt: 80];
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
}


- (void) printJob: (CDVInvokedUrlCommand *) cmd{
    [self performSelectorInBackground: @selector(printJobInBackground:) withObject: cmd];
}

-(BOOL) setTextFont : (NSArray *) args{
    int idx = 0;
    
    for (NSString * name in self.fontList) {
        if ([args[1] isEqualToString:name])
            break;
        idx++;
    }
    
    [self.printer addTextFont: idx];
    return TRUE;
}


-(BOOL) setTextSize : (NSArray *) args{
    int size = [args[1] intValue];
    
    [self.printer addTextSize: size height: size];
    
    return TRUE;
}

-(BOOL) setTextAlign : (NSArray *) args{
    
    if([args[1] integerValue] == 0)
        [self.printer addTextAlign: EPOS2_ALIGN_LEFT];
    if([args[1] integerValue] == 1)
        [self.printer addTextAlign: EPOS2_ALIGN_RIGHT];
    if([args[1] integerValue] == 2)
        [self.printer addTextAlign: EPOS2_ALIGN_CENTER];
    if([args[1] integerValue] == -1)
        [self.printer addTextAlign: EPOS2_ALIGN_LEFT];

    return TRUE;
}
-(BOOL) setLineSpacing : (NSArray *) args{
    [self.printer addLineSpace: [args[1] integerValue]];
    return TRUE;
}

-(BOOL) printText : (NSArray *) args{
    [self.printer addText: @"test"];
   
    return TRUE;
}

-(BOOL) setLangiage : (NSArray *) args{
    
    return TRUE;
}

-(BOOL) setTextStyle : (NSArray *) args{
    
    return TRUE;
}

-(BOOL) printLineFeed : (NSArray *) args{
    [self.printer addFeedLine: [args[1] integerValue]];
    return TRUE;
}


-(UIImage *) loadImageByName: (NSString *) name{
    NSURL *url          = [NSURL URLWithString: name];
    NSData * binData    = [NSData dataWithContentsOfURL: url];
    return [UIImage imageWithData:binData];
}

-(BOOL) printImage : (NSArray *) args{
    UIImage * imageData = [self loadImageByName: args[1]];
    
    [self.printer addImage:imageData
                         x:[args[2] integerValue]
                         y:[args[3] integerValue]
                     width:[args[4] integerValue]
                    height:[args[5] integerValue]
                     color:EPOS2_PARAM_DEFAULT
                      mode:EPOS2_PARAM_DEFAULT
                  halftone:EPOS2_PARAM_DEFAULT
                brightness:3
                  compress:EPOS2_PARAM_DEFAULT];
    
    return TRUE;
}

-(BOOL) printBarcode : (NSArray *) args{
    int barcodeIdx = 0;
    
    for (NSString * name in self.barcodeList) {
        if ([args[2] isEqualToString:name])
            break;
        
        barcodeIdx++;
    }
    
    [self.printer addBarcode: args[1] type: barcodeIdx hri:EPOS2_PARAM_DEFAULT font: EPOS2_PARAM_DEFAULT width: [args[3] integerValue] height: [args[4] integerValue]];
    return TRUE;
}

-(BOOL) startPage : (NSArray *) args{
    [self.printer addPageBegin];
    return TRUE;
}

-(BOOL) endPage : (NSArray *) args{
    [self.printer addPageEnd];
    return TRUE;
}

-(BOOL) cutPaper : (NSArray *) args{
    [self.printer cut: EPOS2_CUT_FEED];
    return TRUE;
}


- (void) printJobInBackground: (CDVInvokedUrlCommand *) cmd{
    
    
    NSInteger t = [self.printer connect: self.target timeout: EPOS2_PARAM_DEFAULT];
    if(t != EPOS2_SUCCESS){
        [self returnError: cmd.callbackId error: DeviceAdapterError_COMMUNICATION];
        return;
    }

    
    NSArray * cmdPool = cmd.arguments;
    
    [self.printer beginTransaction];
    
    [cmdPool enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray * nextCmd = (NSArray *) obj;
        NSString * selName = obj[0];
        SEL sel = NSSelectorFromString([self.cmdMap objectForKey: @"PRINT"]);
        if(sel != nil)
            [self performSelector: sel withObject: nextCmd];
    }];

    [self.printer endTransaction];
    [self.printer disconnect];
    
    [self returnSuccess: cmd.callbackId];
}
- (void) onDiscovery:(Epos2DeviceInfo *)deviceInfo{
    NSLog(@"hh");
}


@end
