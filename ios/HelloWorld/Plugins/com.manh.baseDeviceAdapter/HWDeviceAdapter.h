//
//  HWLayerDevice.h
//  HelloCordova
//
//  Created by Alex on 2016-06-27.
//
//

#import <Cordova/CDVPlugin.h>


//===========================================================

extern const NSString * kDeviceAdapterType_Unknown;
extern const NSString * kDeviceAdapterType_BarcodeScanner;
extern const NSString * kDeviceAdapterType_CardReader;
extern const NSString * kDeviceAdapterType_Printer;
extern const NSString * kDeviceAdapterType_CashDrawer;
extern const NSString * kDeviceAdapterType_PaymentTerminal;
extern const NSString * kDeviceAdapterType_Helper;
//===========================================================

typedef enum __DeviceAdapterError_Type{
    DeviceAdapterError_NO_ERROR         = 0,
    DeviceAdapterError_UNKNOWN_ERROR    = 100,
    DeviceAdapterError_ABSTRACT_METHOD,
    DeviceAdapterError_INVALID_NAME,
    DeviceAdapterError_NOT_INITIALIZED,
    DeviceAdapterError_UNKHOWN_DEVICE,
    DeviceAdapterError_INVALID_ARGUMENT,
    DeviceAdapterError_TOO_LITTLE_ARGUMENTS,
    DeviceAdapterError_TOO_MANY_ARGUMENTS,
    DeviceAdapterError_DEVICE,
    DeviceAdapterError_COMMUNICATION,
    
    DeviceAdapterError_LAST_ERROR
}DeviceAdapterError;



typedef enum __DeviceStatusCode_Type{
    DeviceStatusCode_READY           = 0,
    DeviceStatusCode_DISABLED,
    DeviceStatusCode_NOT_INITIALIZED = 99
}DeviceStatusCode;


@interface HWDeviceAdapter : CDVPlugin

@property (nonatomic, assign) BOOL                deviceIsDisabled;
@property (nonatomic, strong) NSString *          lastErrorMessage;
@property (nonatomic, assign) DeviceAdapterError  lastErrorCode;
@property (nonatomic, strong) NSString *          currentCallbackID;

+(NSString *) getErrorMessage: (DeviceAdapterError) errorId;

-(void) returnError: (NSString *) callbackId error: (DeviceAdapterError) errCode;
-(void) returnSuccess: (NSString *) callbackId;
-(void) returnSuccess: (NSString *) callbackId withString: (NSString *) res;
-(void) sendNotification: (NSString *) name arguments: (id) arguments;
-(void) sendNotificationWithoutEventListeners: (NSString *) name arguments: (id) arguments;
-(void) sendNotificationWithCallbackId: (NSString *) callbackId arguments: (id) arguments;
-(DeviceAdapterError) validateArguments: (NSArray *) arguments min: (NSInteger) min max: (NSInteger) max validation: (NSArray *) regexpList;
-(void) setLastError: (DeviceAdapterError) error description: (NSString *) descr;

-(void) getLastError: (CDVInvokedUrlCommand *) cmd;
-(void) deviceInfo: (CDVInvokedUrlCommand *) cmd;
-(void) deviceType: (CDVInvokedUrlCommand *) cmd;
-(void) deviceStatus: (CDVInvokedUrlCommand *) cmd;
-(void) enableDevice: (CDVInvokedUrlCommand *) cmd;
-(void) disableDevice: (CDVInvokedUrlCommand *) cmd;
-(void) addNotificationListener:(CDVInvokedUrlCommand *) cmd;
-(void) removeNotificationListener:(CDVInvokedUrlCommand *) cmd;
-(void) abstractMethodError: (CDVInvokedUrlCommand *) cmd;
//-(HWDeviceAdapter *) getInitializedInstance: (NSString *) callbackId;
-(NSString *) getDeviceType;
-(BOOL) initializeWithParameters: (CDVInvokedUrlCommand *) cmd;

@end

