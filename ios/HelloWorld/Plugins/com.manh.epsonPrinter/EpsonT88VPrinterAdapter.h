//
//  EpsonT88VPrinter.h
//  EpsonT88VPrinter
//
//  Created by Alex on 2016-10-24.
//  Copyright (c) 2016 Alex Strakholis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWPrinterAdapter.h"
#import "ePOS2.h"


#define PRN_TEXT_ALLIGN_LEFT        0
#define PRN_TEXT_ALLIGN_RIGHT       1
#define PRN_TEXT_ALLIGN_CENTER      2
#define PRN_TEXT_ALLIGN_DEFAULT    -1

#define PRN_TEXT_STYLE_BOLD           1
#define PRN_TEXT_STYLE_ITALIC         2
#define PRN_TEXT_STYLE_UNDERSCORE     4
#define PRN_TEXT_STYLE_NORMAL         0


extern const NSString * kDeviceAdapterName_EpsonT88VPrinter;


@interface EpsonT88VPrinterAdapter : HWPrinterAdapter<Epos2DiscoveryDelegate>

@property (nonatomic, strong) Epos2Printer * printer;
@property (nonatomic, strong) NSString  * target;
@property (nonatomic, strong) NSArray   * fontList;
@property (nonatomic, strong) NSArray   * barcodeList;
@property (nonatomic, assign) int       series;
@property (nonatomic, assign) int       language;
@property (nonatomic, strong) NSDictionary * cmdMap;

@end
