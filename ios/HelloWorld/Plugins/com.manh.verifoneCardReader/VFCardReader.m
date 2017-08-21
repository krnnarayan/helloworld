//
//  VFBarcode.m
//  HelloCordova
//
//  Created by MA-MAC027 on 7/19/16.
//
//
#import    <VMF/VMFramework.h>
#import "VFCardReader.h"

@implementation VFCardReader


+ (VFIPinpad *) pinPad{
    static VFIPinpad *_pinPad = nil;
    if (_pinPad == nil) {
        _pinPad = [[VFIPinpad alloc] init];
    }
    return _pinPad;
}


+ (VFIControl *) control{
    static VFIControl *_control = nil;
    if (_control == nil) {
        _control = [[VFIControl alloc] init];
    }
    return _control;
}


@end
