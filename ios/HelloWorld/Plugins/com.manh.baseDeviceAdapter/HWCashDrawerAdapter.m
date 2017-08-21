//
//  HWCashDrawerAdapter.m
//  HelloCordova
//
//  Created by Alex on 2016-06-28.
//
//

#import "HWCashDrawerAdapter.h"

@implementation HWCashDrawerAdapter

-(const NSString *) getDeviceType{
    return kDeviceAdapterType_CashDrawer;
}


- (void) getDrawerStatus: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}


- (void) getDrawerInfo: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}


-(void) openDrawer: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}


-(void) closeDrawer: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}


-(void) setDrawerSound: (CDVInvokedUrlCommand *) cmd{
    [self abstractMethodError: cmd];
}


@end


