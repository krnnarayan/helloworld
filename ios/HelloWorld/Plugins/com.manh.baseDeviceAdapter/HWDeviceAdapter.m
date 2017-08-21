//
//  HWLayerDevice.m
//  HelloCordova
//
//  Created by Alex on 2016-06-27.
//
//

#import "HWDeviceAdapter.h"

NSString * kDeviceAdapterType_BarcodeScanner    = @"barcode-scanner";
NSString * kDeviceAdapterType_CardReader        = @"card-reader";
NSString * kDeviceAdapterType_Printer           = @"printer";
NSString * kDeviceAdapterType_CashDrawer        = @"cash-drawer";
NSString * kDeviceAdapterType_PaymentTerminal   = @"payment-terminal";
NSString * kDeviceAdapterType_Helper            = @"helper";

@interface HWDeviceAdapter()

@property (nonatomic, strong) NSMutableSet  * evenListeners;

@end

@implementation HWDeviceAdapter



+(NSString *) getErrorMessage:(DeviceAdapterError)errorId{
    static  dispatch_once_t onceToken;
    static  NSDictionary * errorList;
    
    dispatch_once(&onceToken, ^{
        errorList = @{
                      @(DeviceAdapterError_UNKNOWN_ERROR)       : @"Unknown error",
                      @(DeviceAdapterError_ABSTRACT_METHOD)     : @"DeviceAdapter abstract method should not be invoked",
                      @(DeviceAdapterError_INVALID_NAME)        : @"Event listener name is invalid",
                      @(DeviceAdapterError_NOT_INITIALIZED)     : @"Device not initialized",
                      @(DeviceAdapterError_UNKHOWN_DEVICE)      : @"Device in unknown or not supported in current mode",
                      @(DeviceAdapterError_INVALID_ARGUMENT)    : @"Invalid argument",
                      @(DeviceAdapterError_TOO_LITTLE_ARGUMENTS): @"Not anough arguments",
                      @(DeviceAdapterError_TOO_MANY_ARGUMENTS)  : @"Too many arguments",
                      @(DeviceAdapterError_DEVICE)              : @"Device error",
                      @(DeviceAdapterError_COMMUNICATION)       : @"Communication error"

                      };
    });
    
    NSString * resMsg = [errorList objectForKey:@(errorId)];
    
    return [NSString stringWithFormat: @"%d | %@", errorId, resMsg? resMsg : [self getErrorMessage: DeviceAdapterError_UNKNOWN_ERROR]];
}

-(instancetype) init{
    self = [super init];
//    if(self)
//        self.evenListeners = [NSMutableSet new];

    return self;
}

- (void)pluginInitialize{
    self.evenListeners = [NSMutableSet new];
//    NSLog(@"%@",self.evenListeners);
}


-(void) returnError: (NSString *) callbackId error: (DeviceAdapterError) errCode{
    [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString: [HWDeviceAdapter getErrorMessage: errCode]]  callbackId: callbackId];
}


-(void) returnSuccess: (NSString *) callbackId{
    [self.commandDelegate sendPluginResult: [CDVPluginResult resultWithStatus: CDVCommandStatus_OK] callbackId: callbackId];
}

-(void) returnSuccess: (NSString *) callbackId andPluginResult: (CDVPluginResult *) pluginResult {
    [self.commandDelegate sendPluginResult: pluginResult callbackId: callbackId];
}

-(void) returnSuccess: (NSString *) callbackId withString: (NSString *) respString{
    CDVPluginResult * res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString: respString];
    [self returnSuccess: callbackId andPluginResult: res];
}


-(BOOL) initializeWithParameters: (CDVInvokedUrlCommand *) cmd{
    [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
     return true;
}


-(void) setLastError: (DeviceAdapterError) error description: (NSString *) descr{
    self.lastErrorCode      = error;
    self.lastErrorMessage   = descr;
}


-(void) getLastError: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                         messageAsDictionary: @{@"code"     : @(self.lastErrorCode),
                                                                @"details"  : self.lastErrorMessage}];
    
    [self.commandDelegate sendPluginResult: res callbackId: cmd.callbackId];
}


-(void) deviceInfo:(CDVInvokedUrlCommand *)cmd{
    [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
}


-(void) deviceStatus: (CDVInvokedUrlCommand *) cmd{
    [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
}


-(void) enableDevice: (CDVInvokedUrlCommand *) cmd{
    [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
}


-(void) disableDevice: (CDVInvokedUrlCommand *) cmd{
    [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
}


-(void) deviceType: (CDVInvokedUrlCommand *) cmd{
    NSString * devType = [self getDeviceType];
    
    if(devType != nil)
        [self returnSuccess: cmd.callbackId withString: devType];
    else
        [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
    
}

-(void) addNotificationListener:(CDVInvokedUrlCommand *) cmd{
    
    self.currentCallbackID = [[NSString alloc]initWithString:cmd.callbackId];
    
    
    NSString * listener =[cmd.arguments firstObject];
    
    if(listener.length){
        [self.evenListeners addObject:  listener];
       // [self returnSuccess: cmd.callbackId];
    }
    else{
        [self returnError: cmd.callbackId error: DeviceAdapterError_INVALID_NAME];
    }
}


-(void) removeNotificationListener:(CDVInvokedUrlCommand *) cmd{
    NSString * listener =[cmd.arguments firstObject];
    
    if(listener.length)
        [self.evenListeners removeObject: listener];
    
    [self returnSuccess: cmd.callbackId];
    
}


-(void) sendNotification: (NSString *) name arguments: (id) arguments {
    
    NSDictionary * dict = @{
                            @"name" : name,
                            @"args" : arguments? arguments : [NSNull null]
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: dict
                                                       options:0
                                                         error:&error];

    if(jsonData){
        NSString * argList = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self.evenListeners enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSString * listener = (NSString *) obj;
            [self.commandDelegate evalJs: [NSString stringWithFormat:@"%@(%@);", listener, argList]];
        }];
    }
}

-(void) sendNotificationWithoutEventListeners: (NSString *) name arguments: (id) arguments {
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:arguments];
    pluginResult.keepCallback = [NSNumber numberWithInt:CDVCommandStatus_OK];
    [self returnSuccess:self.currentCallbackID andPluginResult:pluginResult];
    
}
-(void) sendNotificationWithCallbackId: (NSString *) callbackId arguments: (id) arguments
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:arguments];
    pluginResult.keepCallback = [NSNumber numberWithInt:CDVCommandStatus_OK];
    [self returnSuccess:callbackId andPluginResult:pluginResult];
}

-(NSString *) getDeviceType{
    return nil;
}

/*
-(HWDeviceAdapter *) getInitializedInstance: (NSString *) callbackId{
    HWDeviceAdapter * adapter = [[HWDeviceAdapterManager instance] getDeviceInstanceByType: [self getDeviceType]];
    if(!adapter)
        [self returnError: callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
    
    adapter.commandDelegate = self.commandDelegate;
    return adapter;
}
*/


-(void) abstractMethodError: (CDVInvokedUrlCommand *) cmd{
    [self returnError: cmd.callbackId error: DeviceAdapterError_ABSTRACT_METHOD];
}

-(DeviceAdapterError) validateArguments: (NSArray *) arguments min: (NSInteger) min max: (NSInteger) max validation: (NSArray *) regexpList{
    __block DeviceAdapterError resCode = DeviceAdapterError_NO_ERROR;
    NSInteger argCount = arguments.count;
    
    if(argCount < min){
        [self setLastError: DeviceAdapterError_TOO_LITTLE_ARGUMENTS description: [NSString stringWithFormat: @"Not enough arguments: %ld. At least %ld argument(s) required", (long)argCount, (long)min]];
        return DeviceAdapterError_TOO_LITTLE_ARGUMENTS;
    }
    
    if(argCount > max){
        [self setLastError: DeviceAdapterError_TOO_MANY_ARGUMENTS description: [NSString stringWithFormat: @"To many arguments: %ld. Max %ld argument(s) required", (long)argCount, (long)max]];
        return DeviceAdapterError_TOO_MANY_ARGUMENTS;
    }
    
    [regexpList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx < argCount){
            NSString * pattern =(NSString *) obj;
            
            if(pattern.length){
                NSError * err;
                NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: &err];
                
                if(!err){
                    NSString  * nextArgument = [arguments objectAtIndex: idx];
                    NSTextCheckingResult * match = [regex firstMatchInString:   nextArgument options: 0 range: (NSRange){0, nextArgument.length}];
                    if(match.range.location != 0 || match.range.length != nextArgument.length){
                        resCode = DeviceAdapterError_INVALID_ARGUMENT;
                        *stop = YES;
                        [self setLastError: DeviceAdapterError_INVALID_ARGUMENT description: [NSString stringWithFormat: @"Invalid argument at index %lu -> %@. The argument should match: %@", (unsigned long)idx, nextArgument, pattern]];
                    }
                }
            }
        }
        else{
            *stop = YES;
        }
    }];
    
    return resCode;
}

@end
