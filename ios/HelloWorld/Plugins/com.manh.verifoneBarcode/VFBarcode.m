//
//  VFBarcode.m
//  HelloCordova
//
//  Created by MA-MAC027 on 7/19/16.
//
//
#import    <VMF/VMFramework.h>
#import "VFBarcode.h"

@implementation VFBarcode


+ (VFIBarcode *) barcode{
    static VFIBarcode *_barcode = nil;
    if (_barcode == nil) {
        _barcode = [[VFIBarcode alloc] init];
    }
    return _barcode;
}




@end
