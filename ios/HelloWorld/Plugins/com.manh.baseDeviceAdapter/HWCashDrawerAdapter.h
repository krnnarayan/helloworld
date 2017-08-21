//
//  HWCashDrawerAdapter.h
//  HelloCordova
//
//  Created by Alex on 2016-06-28.
//
//

#import "HWDeviceAdapter.h"

// @ public cordova interface

@interface HWCashDrawerAdapter : HWDeviceAdapter

- (void) getDrawerStatus: (CDVInvokedUrlCommand *) cmd;
- (void) getDrawerInfo: (CDVInvokedUrlCommand *) cmd;
- (void) openDrawer: (CDVInvokedUrlCommand *) cmd;
- (void) closeDrawer: (CDVInvokedUrlCommand *) cmd;
- (void) setDrawerSound: (CDVInvokedUrlCommand *) cmd;


@end

// @ private iOS specific implementation


enum {
    HWCDErrorInternal = 100,
    HWCDErrorNotFound,
    HWCDErrorUnknownType,
    HWCDErrorNotSelected,
    HWCDErrorNotImplemented,
    HWCDErrorConfiguration,
    HWCDErrorCommandPending,
    HWCDErrorTimeout,
};

extern NSString * const HWCashDrawerErrorDomain;

@interface HWCashDrawerInfo : NSObject

@property (nonatomic, strong) NSString * drawerName;
@property (nonatomic, strong) NSString * drawerType;
@property (nonatomic, strong) NSString * drawerModel;
@property (nonatomic, strong) NSString * drawerStatus;
@property (nonatomic, strong) NSString * serialNumber;
@property (nonatomic, strong) NSString * commSettings;
@property (nonatomic, assign) NSTimeInterval pollingFrequency;
@property (nonatomic, assign) NSTimeInterval timeout;

@end



