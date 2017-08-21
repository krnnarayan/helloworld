//
//  VerifoneCardReaderAdapter.m
//
//
//
//
//
#import "VerifoneCardReaderAdapter.h"
#import "VFCardReader.h"

static bool started = false;

@implementation PinEntryResult
@end

@implementation CardEntryResult
@end

@implementation ReaderData
@synthesize pan, track1, track2, track3, cardNumber, nameOnCard, expMonth, expYear, parsed, extraInfo, hardwareInfo;
@end

@implementation HardwareInfo
@synthesize name, serialNumber, hardwareVersion, softwareVersion, engineClassName;
@synthesize state, changeReason, barcodeConnected, readerConnected;
@end


NSString * kDeviceAdapterName_VFICardReader = @"VeriFone Card Reader";

@implementation VerifoneCardReaderAdapter

@synthesize pkiCert, pkiID; //pinpad, control;

- (id)init {
    
    self = [super init];
//    if(self) {
//        [self initVerifone];
//    }
    
    return self;
}


-(void) deviceInfo: (CDVInvokedUrlCommand *) cmd{
    CDVPluginResult *res = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                                         messageAsDictionary:   @{@"device"     : kDeviceAdapterName_VFICardReader,
                                                                  @"type"       : kDeviceAdapterType_CardReader,
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

- (void)pluginInitialize{
    [super pluginInitialize];
    [self initVerifone];
}

-(BOOL) initializeWithParameters: (CDVInvokedUrlCommand *) cmd{
    [self returnSuccess: cmd.callbackId];
    return  true;
}

-(void) hasPinpad: (CDVInvokedUrlCommand *) cmd {
    
}

-(void) enablePinpad: (CDVInvokedUrlCommand *) cmd {
    
    [self onSetup];
    self.currentCallbackID = [[NSString alloc]initWithString:cmd.callbackId];
    
}

-(void) disablePinpad: (CDVInvokedUrlCommand *) cmd {
    
    [self closeVerifone];
    [self returnSuccess: cmd.callbackId];
}

-(void) cancelOperation: (CDVInvokedUrlCommand *) cmd {
    
    [self abortCurrectPinpadOperation];
    [self returnSuccess: cmd.callbackId];
    
}

-(void) requestPinEntry: (CDVInvokedUrlCommand *) cmd {
    
    //HardCoding CardNumber for testing purpose
    
    [self requestPinEntry:@"5454545454545454" withSuccessBlock:^(PinEntryResult *result) {
        NSLog(@"RequestPinEntry success Block PinEntryResult result %@",result);
        [self returnSuccess: cmd.callbackId];
    } andFailBlock:^(NSError *error) {
        NSLog(@"RequestPinEntry Failure Block error %@", error);
    }];
    
}

-(void) requestCardEntry: (CDVInvokedUrlCommand *) cmd {
    
    [self requestCardEntryWithSuccessBlock:^(ReaderData *result) {
        NSLog(@"RequestCardEntry success Block ReaderData result %@",result);
        [self returnSuccess: cmd.callbackId];
    } andFailBlock:^(NSError *error) {
        NSLog(@"RequestCardEntry Failure Block error %@", error);
    }];
    
}

-(void) requestTextEntry: (CDVInvokedUrlCommand *) cmd {
    
    [self requestTextEntryWithPrompts:@[@"Choose the", @"type of card"] choices:@[@"Credit", @"Debit "] andFinishBlock:^(TextEntryResult result) {
        
        NSLog(@"requestTextEntry TextEntryResult result %ld",(long)result);
        [self returnSuccess: cmd.callbackId];
    }];
    
}



-(void)onSetup
{
    scanEnabled = NO;
    msrEnabled = NO;
    
    bcInit = false;
    controlInit = false;
    pinpadInit = false;
    
    bcConnected = false;
    ctlConnected = false;
    pinConnected = false;
    
    timeoutFlag = false;
    _state = STATE_INIT;
    _ranCheckDigit = false;
    _injectedPKI = false;
    _encryptionMode = EncryptionMode_VSP;
    _encryptionOn = true;
    
    lookups = [[NSMutableDictionary alloc] init];
    [lookups setValue:@"Successful PKI update" forKey:@"ENC_00000000"];
    [lookups setValue:@"Parameter Error. NULL or out of Range."forKey:@"ENC_00001000"];
    [lookups setValue:@"Invalid Public Key File."forKey:@"ENC_00001001"];
    [lookups setValue:@"Encryption Failed." forKey:@"ENC_00001002"];
    [lookups setValue:@"Too small output buffer." forKey:@"ENC_00001003"];
    [lookups setValue:@"Invalid Key ID File."forKey:@"ENC_00001004"];
    [lookups setValue:@"Error in opening DataFile."forKey:@"ENC_00001005"];
    [lookups setValue:@"Error in Hash Key computation."forKey:@"ENC_00001006"];
    [lookups setValue:@"Unknown or unexpected error." forKey:@"ENC_00001100"];
    
    [self initVerifone];
}

-(void) onStop {
    [self closeVerifone];
}

-(HardwareInfo*)hardwareInfo
{
    _hardwareInfo.name = @"Verifone";
    _hardwareInfo.serialNumber = [self getPinpadSerialNumber];
    _hardwareInfo.hardwareVersion = @"";
    _hardwareInfo.softwareVersion = [self getFrameworkVersion];
    _hardwareInfo.engineClassName = @"VMFScanSwipeEngine";
    
    if(_state==STATE_INIT)
        _hardwareInfo.state = SS_HW_INIT;
    else if(_state==STATE_BUSY)
        _hardwareInfo.state = SS_HW_BUSY;
    else if(_state==STATE_CONNECTED)
        _hardwareInfo.state = SS_HW_CONNECTED;
    else
        _hardwareInfo.state = SS_HW_DISCONNECTED;
    
    _hardwareInfo.barcodeConnected = bcConnected;
    _hardwareInfo.readerConnected = ctlConnected;
    
    return _hardwareInfo;
}

-(void)_checkState
{
    if(ctlConnected && pinConnected)
        [self changeState:STATE_CONNECTED];
    else if([self isSledConnected])
        [self changeState:STATE_BUSY];
    else
        [self changeState:STATE_DISCONNECTED];
}


-(bool)isBusy
{
    return (_state == STATE_BUSY);
}

-(bool)isConnected
{
    return (_state == STATE_CONNECTED);
}


- (void)initVerifone
{
    //    @try
    //    {
    //        if(_state!=STATE_INIT)
    //            return;
    //    }
    //    @catch (NSException *e)
    //    {
    //        NSLog(@"Verifone Info Exception - %@", e.reason);
    //    }
    //
    //    @try
    //    {
    //        if(started)
    //            return;
    //    }
    //    @catch (NSException *e)
    //    {
    //        NSLog(@"Verifone Info Exception - %@", e.reason);
    //    }
    
    started = YES;
    
    /*if ([VFCardReader pinPad] == nil)
    {
        [VFCardReader pinPad] = [[VFIPinpad alloc] init];
    }*/
    
    [[VFCardReader pinPad] setDelegate:self];
    [[VFCardReader pinPad] logEnabled:false];
    [[VFCardReader pinPad] initDevice];
    [[VFCardReader pinPad] enableMSRDualTrack];
    
    /*if (control == nil)
    {
        control = [[VFIControl alloc] init];
    }*/
    [[VFCardReader control] setDelegate:self];
    [[VFCardReader control] logEnabled:false];
    [[VFCardReader control] initDevice];
    
    msrEnabled = TRUE;
    HardwareInfo* hw = self.hardwareInfo;
    hw.changeReason = SS_HW_CHANGE_STATE;
}

- (void)closeVerifone
{
    started = false;
    self.currentCallbackID = nil;
    @try
    {
        if([VFCardReader pinPad]!=nil)
        {
            [[VFCardReader pinPad] closeDevice];
            [[VFCardReader pinPad] setDelegate:nil];
        }
        
        if([VFCardReader control]!=nil)
        {
            [[VFCardReader control] closeDevice];
            [[VFCardReader control] setDelegate:nil];
        }
    }
    @catch (NSException *exception)
    {
    }
}


- (BOOL)isPinpadConnected {
    return [VFCardReader pinPad].connected;
}

- (void)forceEnablePinpad
{
    if(![self isConnected])
        return ;
    
    if ([[[[VFCardReader pinPad] vfiDiagnostics] xpiVersion] doubleValue] < 5.0)
    {
        [[VFCardReader pinPad] enableMSR];
    } else
    {
        [[VFCardReader pinPad] enableMSRDualTrack];
    }
}

- (NSString *)getPinpadSerialNumber
{
    return [VFCardReader pinPad].vfiDiagnostics.pinpadSerialNumber;
}

- (NSString *)getFrameworkVersion
{
    return [VFCardReader pinPad].frameworkVersion;
}

- (double) xpiVersion
{
    return [[[[VFCardReader pinPad] vfiDiagnostics] xpiVersion] doubleValue];
}



#pragma mark -
#pragma mark Pinpad

- (void)pinpadConnected:(BOOL)isConnected
{
    pinConnected = isConnected;
    
    [self _checkState];
}

- (void)pinpadDataReceived:(NSData *)data
{
}

- (void)pinpadDataSent:(NSData *)data
{
}

-(BOOL)triggerEncIssues:(BOOL)withMessage
{
    if((_encryptionMode == EncryptionMode_PKI) && !_encryptionOn)
    {
        if(withMessage)
        {
            // show error alert
        }
        
        return YES;
    }
    
    return NO;
}

//- (void)pinpadMSRData:(NSString *)pan expMonth:(NSString *)month expYear:(NSString *)year trackData:(NSString *)track2
//{
//    if(!msrEnabled)
//        return ;
//    
//    if([self triggerEncIssues:YES])
//    {
//        return ;
//    }
//    
//    ReaderData* data = [ReaderData new];
//    data.hardwareInfo = self.hardwareInfo;
//    data.pan = pan;
//    data.track2 = track2;
//    data.expMonth = [month integerValue];
//    data.expYear = [year integerValue];
//    data.parsed = YES;
//    
//    NSString *cardInfo = [NSString stringWithFormat:@"!!ReaderData NFC-pinpadMSRData- track1(%@) track2(%@) track3(%@) pan(%@) nameOnCard(%@) expYear(%ld)", data.track1,data.track2, data.track3, data.pan, data.nameOnCard, (long)data.expYear ];
//    
//    [self triggerCipher];
//   // [self sendNotificationWithoutEventListeners:@"barcode-scanned" arguments: cardInfo];
//}

- (void)pinpadMSRData:(NSString *)pan expMonth:(NSString *)month expYear:(NSString *)year track1Data:(NSString *)track1 track2Data:(NSString *)track2
{
    if(!msrEnabled)
        return ;
    
    if([self triggerEncIssues:NO])
    {
        return ;
    }
    
    ReaderData* data = [ReaderData new];
    data.hardwareInfo = self.hardwareInfo;
    data.pan = pan;
    data.track1 = track1;
    data.track2 = track2;
    data.expMonth = [month integerValue];
    data.expYear = [year integerValue];
    data.parsed = YES;
    
    NSLog(@"!!ReaderData NFC-pinpadMSRData2- track1(%@) track2(%@) track3(%@) pan(%@) nameOnCard(%@) expYear(%ld)", data.track1,data.track2, data.track3, data.pan, data.nameOnCard, (long)data.expYear);
    
    
    /*
     if (delegate != nil && [delegate respondsToSelector:@selector(vfPinpadMSRData:expMonth:expYear:track1Data:track2Data:)] && [[[pinpad vfiDiagnostics] xpiVersion] doubleValue] >= 5.0)
     {
     [delegate vfPinpadMSRData:pan expMonth:month expYear:year track1Data:track1 track2Data:track2];
     }
     */
    NSString *track1data = [NSString stringWithFormat:@"Track1(%@)\n Track2(%@)\n Pan-masked(%@)\n expMonth(%ld)\n expYear(%ld)", data.track1,data.track2, data.pan, (long)data.expMonth, (long)data.expYear];
    [self sendNotificationWithoutEventListeners:@"CardReaderData" arguments: track1data];
    [self triggerCipher];
}

- (void)pinpadDownloadInfo:(NSString *)log {
    //[GBULog info:mPOSLogHardware method:@"pinpadDownloadInfo" format:@"pinpadDownloadInfo: %@", log];
}

- (void)pinpadDownloadBlocks:(int)TotalBlocks sent:(int)BlocksSent {
    //[GBULog info:mPOSLogHardware method:@"pinpadDownloadBlocks" format:@"pinpadDownloadBlocks: %d sent: %d", TotalBlocks, BlocksSent];
}

- (void)controlConnected:(BOOL)isConnected
{
    ctlConnected = isConnected;
    
    [self _checkState];
}


#pragma mark -
#pragma mark Control

- (void)controlLogEntry:(NSString *)logEntry withSeverity:(int)severity {
    
}

- (void)controlDataReceived:(NSData *)data {
}

- (void)controlDataSent:(NSData *)data {
}

-(void)barcodeReconnectStarted
{
}

-(void)pinpadReconnectStarted
{
}

-(void)controlReconnectStarted
{
}

-(void)barcodeReconnectFinished
{
    
}

-(void)pinpadReconnectFinished
{
}

-(void)controlReconnectFinished
{
}

-(void)changeState:(int)newState
{
    if(_state==newState)
        return ;
    
    @try
    {
        _state = newState;
        
        if(_state==STATE_CONNECTED)
        {
            //      [self enablePinpad:self.manager.readerEnabled];
            //      [self enableBarcode:self.manager.barcodeEnabled];
        }
        
        HardwareInfo* hw = self.hardwareInfo;
        hw.changeReason = SS_HW_CHANGE_STATE;
        
        NSLog(@"changeState: %d", _state);
    }
    @catch (NSException *exception)
    {
        NSLog(@"VMF.changeState: %@", exception.description);
    }
}

-(void) log:(NSString *)target message:(NSString *)message, ...
{
    @try
    {
        va_list args;
        va_start(args, message);
        
        NSString* resolvedMessage = [[NSString alloc] initWithFormat:message arguments:args];
        
        //if([delegate respondsToSelector:@selector(vfLogToApp:)])
        //  [delegate vfLogToApp:resolvedMessage];
        
        va_end(args);
    }
    @catch (NSException *e)
    {
        NSLog(@"!!!!! VMFLOG: %@", [e description]);
    }
}


#pragma mark -
#pragma mark EAAccessory Delegate

-(bool)isSledConnected
{
    return pinConnected;
}


-(void)checkAndLoadPKI
{
    if(![self isConnected])
        return ;
    
    if(_injectedPKI)
        return ;
    
    if(pkiCert==nil || pkiID==nil)
    {
        [[VFCardReader pinPad] selectEncryptionMode:EncryptionMode_VSP];
        return ;
    }
    
    _injectedPKI = true;
    [[VFCardReader pinPad] selectEncryptionMode:EncryptionMode_PKI];
    _encryptionMode = EncryptionMode_PKI;
    _encryptionOn = true;
    
    NSString* result = nil;
    int didit = [[VFCardReader pinPad] E08_RSA:pkiCert publicKeyID:pkiID];
    if(didit==1)
    {
        _encryptionOn = false;
        
        NSString* errorid = [[VFCardReader pinPad] keyLoadErrorCode];
        if(errorid!=nil)
            result = [NSString stringWithFormat:@"[%@]", [lookups valueForKey:[NSString stringWithFormat:@"ENC_%@", errorid]]];
        else
            result = @"[NO ERROR CODE FOUND]";
        
        NSString* errorMessage = [NSString stringWithFormat:@"Problem setting PKI\n%@", result];
        NSLog(@"errorMessage : %@",errorMessage);
        
        result =[NSString stringWithFormat:@"Failed[%@] %@", pkiID, result];
    }
    else
    {
        result =[NSString stringWithFormat:@"Success[%@]", pkiID];
    }
    
    [self log:@"VMF" message:@"Switched to PKI Mode - %@", result];
}

-(void)triggerCipher
{
    //if(delegate == nil)
    //  return ;
    
    if (_encryptionMode == EncryptionMode_PKI)
    {
        [[VFCardReader pinPad] getPKICipheredData];
    }
}


- (void)dealloc
{
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
}


- (void)abortCurrectPinpadOperation {
    [[VFCardReader pinPad] S00];
}

- (void)requestPinEntry:(NSString *)pan withSuccessBlock:(SuccessPinEntryBlock)successBlock andFailBlock:(FailPinEntryBlock)failBlock {
    NSAssert([[NSThread currentThread] isEqual:[NSThread mainThread]], @"\rRequest available only from main thread");
    
    [[VFCardReader control] keypadBeepEnabled:YES];
    [[VFCardReader control] keypadEnabled:YES];
    
    int value = [[VFCardReader pinPad] Z62:pan minPIN:4 maxPIN:8 requirePIN:YES firstMessage:@"ENTER PIN" secondMessage:@"" processingMessage:@"Processing..."];
    value = [[VFCardReader pinPad] requestPINRentry:pan];
    
    [[VFCardReader control] keypadEnabled:NO];
    if (value < 0)
    {
        [[VFCardReader pinPad] S01];
        NSString * mesage = @"Invalid return";
        if (value == VFIResultCode_Framework_Timeout)
        {
            [[VFCardReader pinPad] displayMessages:@"PIN" Line2:@"Entry" Line3:@"Timeout..." Line4:@""];
            mesage = @"Pin entry framework timeout...";
        }
        else if (value == VFIResultCode_ACK_Timeout)
        {
            [[VFCardReader pinPad] displayMessages:@"PIN" Line2:@"Entry" Line3:@"ACK timeout..." Line4:@""];
            mesage = @"Pin entry ACK timeout...";
        }
        else if (value == VFIResultCode_Framework_Invalid_Data)
        {
            [[VFCardReader pinPad] displayMessages:@"PIN" Line2:@"Entry" Line3:@"Invalid data..." Line4:@""];
            mesage = @"Pin entry ACK timeout...";
        }
        else if (value == VFIResultCode_Framework_No_Blocking)
        {
            [[VFCardReader pinPad] displayMessages:@"PIN" Line2:@"Entry" Line3:@"Invalid data..." Line4:@""];
            mesage = @"Pin entry No blocking...";
        }
        else if (value == VFIResultCode_Device_Not_Available)
        {
            mesage = @"Device not available...";
        }
        failBlock([NSError errorWithDomain:mesage code:value userInfo:nil]);
        
        return;
    }
    
    NSString *pinData = [[NSString alloc] initWithData:[VFCardReader pinPad].vfiEncryptionData.pinBlock encoding:NSASCIIStringEncoding];
    NSString *serialNumber = [VFCardReader pinPad].vfiEncryptionData.serialNumber;
    
    if (pinData && serialNumber && pinData.length > 0 && serialNumber.length > 0)
    {
        PinEntryResult *result = [PinEntryResult new];
        result.pin = [pinData copy];
        result.ksn = [serialNumber copy];
        [[VFCardReader pinPad] displayMessages:@"PIN" Line2:@"ENTER" Line3:@"DONE" Line4:@""];
        successBlock(result);
    }
    else
    {
        failBlock([NSError errorWithDomain:@"vfiEncryptionData.pinBlock or vfiEncryptionData.serialNumber values are incorrect" code:value userInfo:nil]);
        
        //        [[[GBLAlertView alloc] initWithTitle:@"VMF.framework" message:[NSString stringWithFormat:@"Error from method Z62. Result Code is: %i", value] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
        NSLog(@"%@",[NSString stringWithFormat:@"Error from method Z62. Result Code is: %i", value]);
        
        [[VFCardReader pinPad] S01];
    }
    [[[VFCardReader pinPad] vfiEncryptionData] clear];
    NSLog(@"ENTER PIN - DONE");
}

- (ReaderData*)readerDataFromS16Track1:(NSString*)track1 track2:(NSString*)track2 accountNumber:(NSString*)accountNumber expirationDate:(NSString*)expirationDate contactless:(BOOL)contactless{
    NSString *cardholderName = @"";
    NSArray *components = [track1 componentsSeparatedByString:@"^"];
    
    ReaderData *readerData = [ReaderData new];
    readerData.track1 = track1;
    readerData.track2 = track2;
    readerData.cardNumber = accountNumber;
    readerData.contactless = contactless;
    if ([expirationDate length] == 4) {
        readerData.expYear = [[expirationDate substringWithRange:NSMakeRange(0, 2)] integerValue];
        readerData.expMonth = [[expirationDate substringWithRange:NSMakeRange(2, 2)] integerValue];
    }
    
    readerData.hardwareInfo = self.hardwareInfo;
    
    if ([components count] == 3) {
        cardholderName = [components objectAtIndex:1];
        if ([accountNumber length] == 0) {
            NSString *pan = [components objectAtIndex:0];
            pan = [pan substringFromIndex:2];
            readerData.cardNumber = pan;
        }
        if ([expirationDate length] == 0) {
            NSString *year = [components objectAtIndex:2];
            NSString *month = [components objectAtIndex:2];
            readerData.expYear = [[year substringWithRange:NSMakeRange(1, 2)] integerValue];
            readerData.expMonth = [[month substringWithRange:NSMakeRange(3, 2)] integerValue];
        }
    } else {
        if ([accountNumber length] == 0) {
            NSRange equalSignPos = [track2 rangeOfString:@"="];
            if (equalSignPos.location != NSNotFound) {
                NSString *ccNum = [track2 substringToIndex:equalSignPos.location];
                readerData.cardNumber = [ccNum stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
            }
        }
        if ([expirationDate length] == 0) {
            NSRange equalSignPos = [track2 rangeOfString:@"="];
            if (equalSignPos.location != NSNotFound) {
                NSString *exDate = [track2 substringWithRange:NSMakeRange(equalSignPos.location + 1, 4)];
                readerData.expYear = [[exDate substringWithRange:NSMakeRange(0, 2)] integerValue];
                readerData.expMonth = [[exDate substringWithRange:NSMakeRange(2, 2)] integerValue];
            }
        }
    }
    return readerData;
}

- (void)requestCardEntryWithAmount:(NSInteger)amount withSuccessBlock:(SuccessCardEntryBlock)successBlock andFailBlock:(FailCardEntryBlock)failBlock {
    NSAssert([[NSThread currentThread] isEqual:[NSThread mainThread]], @"\rRequest available only from main thread");
    
    [[VFCardReader control] keypadBeepEnabled:YES];
    [[VFCardReader control] keypadEnabled:YES];
    
    int value = [[VFCardReader pinPad] C30:60 language:0 amount:amount otherAmount:amount];
    
    [[VFCardReader control] keypadEnabled:NO];
    [[VFCardReader control] keypadBeepEnabled:NO];
    
    NSError *error;
    if (value != 21)
    {
        error = [[NSError alloc] initWithDomain:@"Invalid return" code:value userInfo:nil];
        if (value == VFIResultCode_Framework_Timeout || value == 6)
        {
            
            [[VFCardReader pinPad] displayMessages:@"Card" Line2:@"Entry" Line3:@"Timeout..." Line4:@""];
            error = [[NSError alloc] initWithDomain:@"Card Entry Timeout " code:VFIResultCode_Framework_Timeout userInfo:nil];
        } else if (value == 3) {
            
            error = [[NSError alloc] initWithDomain:@"Card Entry Canceled" code:value userInfo:nil];
        }
        //                dispatch_async(dispatch_get_main_queue(), ^{
        failBlock(error);
        //                });
        
        return;
    }
    
    VFICardData *cardData = [[VFCardReader pinPad] vfiCardData];
    
    if (cardData && (cardData.s16track2 || cardData.accountNumber))
    {
        CardEntryResult *result = [CardEntryResult new];
        ReaderData *readerData = [self readerDataFromS16Track1:[[NSString alloc] initWithData:cardData.track1 encoding:NSUTF8StringEncoding] track2:[[NSString alloc] initWithData:cardData.track2 encoding:NSUTF8StringEncoding] accountNumber:cardData.accountNumber expirationDate:cardData.expiryDate contactless: (cardData.entryType==91)];
        //                dispatch_async(dispatch_get_main_queue(), ^{
        
        //NSLog(@"!!ReaderData CONTACTLESS entryType - (%d)", cardData.entryType);
        
        
        //NSLog(@"!!ReaderData NFC-requestCardEntryWitAmount- track1(%@) track2(%@) track3(%@) pan(%@) nameOnCard(%@) expYear(%d)", readerData.track1,readerData.track2, readerData.track3, readerData.pan, readerData.nameOnCard, readerData.expYear);
        
        successBlock(readerData);
        //                });
    }
    else
    {
        error = [[NSError alloc] initWithDomain:@"Card Entry Data nil" code:0 userInfo:nil];
        //                dispatch_async(dispatch_get_main_queue(), ^{
        [self abortCurrectPinpadOperation];
        failBlock(error);
        //                });
        NSLog(@"%@",[NSString stringWithFormat:@"Error from method s16. Result Code is: %i", value]);
        return;
    }
    [[[VFCardReader pinPad] vfiEncryptionData] clear];
    NSLog(@"ENTER CARD DATA - DONE");
}

- (void)requestCardEntryWithSuccessBlock:(SuccessCardEntryBlock)successBlock andFailBlock:(FailCardEntryBlock)failBlock {
    //    static NSOperationQueue *queue = nil;
    //    if (queue == nil) {
    //        queue = [NSOperationQueue new];
    //        queue.maxConcurrentOperationCount = 1;
    //    }
    
    //    [queue addOperationWithBlock:^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    NSAssert([[NSThread currentThread] isEqual:[NSThread mainThread]], @"\rRequest available only from main thread");
    
    [[VFCardReader control] keypadBeepEnabled:YES];
    [[VFCardReader control] keypadEnabled:YES];
    
    int value = [[VFCardReader pinPad] S16:0 displayIdle:YES displayExpiry:YES luhnCheck:YES entryMode:3];
    
    [[VFCardReader control] keypadEnabled:NO];
    [[VFCardReader control] keypadBeepEnabled:NO];
    
    NSError *error;
    if (value != 0)
    {
        error = [[NSError alloc] initWithDomain:@"Invalid return" code:value userInfo:nil];
        if (value == VFIResultCode_Framework_Timeout || value == 2)
        {
            
            [[VFCardReader pinPad] displayMessages:@"Card" Line2:@"Entry" Line3:@"Timeout..." Line4:@""];
            error = [[NSError alloc] initWithDomain:@"Card Entry Timeout " code:VFIResultCode_Framework_Timeout userInfo:nil];
        } else if (value == 3) {
            error = [[NSError alloc] initWithDomain:@"Card Entry Canceled" code:value userInfo:nil];
        }
        //                dispatch_async(dispatch_get_main_queue(), ^{
        failBlock(error);
        //                });
        
        return;
    }
    
    VFICardData *cardData = [[VFCardReader pinPad] vfiCardData];
    if (cardData && (cardData.s16track2 || cardData.accountNumber))
    {
        CardEntryResult *result = [CardEntryResult new];
        ReaderData *readerData = [self readerDataFromS16Track1:[[NSString alloc] initWithData:cardData.s16track1 encoding:NSUTF8StringEncoding] track2:[[NSString alloc] initWithData:cardData.s16track2 encoding:NSUTF8StringEncoding] accountNumber:cardData.accountNumber expirationDate:cardData.expiryDate contactless:(cardData.entryType==91)];
        //                dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"!!ReaderData CONTACTLESS entryType - (%d)", cardData.entryType);
        
        NSLog(@"!!ReaderData NFC-requestCardEntryWithSuccessBlock- track1(%@) track2(%@) track3(%@) pan(%@) nameOnCard(%@) expYear(%ld)", readerData.track1,readerData.track2, readerData.track3, readerData.pan, readerData.nameOnCard, (long)readerData.expYear);
        
        successBlock(readerData);
        //                });
    }
    else
    {
        error = [[NSError alloc] initWithDomain:@"Card Entry Data nil" code:0 userInfo:nil];
        //                dispatch_async(dispatch_get_main_queue(), ^{
        [self abortCurrectPinpadOperation];
        failBlock(error);
        //                });
        NSLog(@"%@",[NSString stringWithFormat:@"Error from method s16. Result Code is: %i", value]);
        return;
    }
    [[[VFCardReader pinPad] vfiEncryptionData] clear];
    NSLog(@"ENTER CARD DATA - DONE");
    //        });
    //    }];
}

- (void)requestTextEntryWithPrompts:(NSArray*)promptLines choices:(NSArray*)choices andFinishBlock:(TextEntryFinishBlock)finishblock
{
    NSParameterAssert(promptLines);
    NSParameterAssert(choices);
    NSAssert(choices.count < 5, @"choices must be less than 5");
    NSAssert(choices.count < 3, @"choices must be less than 3");
    
    for (NSString *string in promptLines)
    {
        NSAssert(string.length < 17, @"prompt line length must be less than 17");
    }
    for (NSString *string in choices)
    {
        NSAssert(string.length < 17, @"choice length must be less than 17");
    }
    
    [[VFCardReader control] keypadBeepEnabled:YES];
    [[VFCardReader control] keypadEnabled:YES];
    
    NSLog(@"Requesting keyboard input");
    
    int res = [[VFCardReader pinPad] menuChoiceSelection:(promptLines.count > 0 ? promptLines[0] : @"")
                                      message2:(promptLines.count > 1 ? promptLines[1] : @"")
               
                                       choice1:(choices.count > 0 ? choices[0] : @"")
                                       choice2:(choices.count > 1 ? choices[1] : @"")
                                       choice3:(choices.count > 2 ? choices[2] : @"")
                                       choice4:(choices.count > 3 ? choices[3] : @"")];
    
    
    TextEntryResult result = TextEntryResultInvalid;
    if (res == 0)
    {
        result = TextEntryResultOK;
    }
    else if (res == 1)
    {
        result = TextEntryResultUnseccussful;
    }
    else if (res == 2)
    {
        result = TextEntryResultTimeOut;
    }
    else if (res == 3)
    {
        result = TextEntryResultCancel;
    }
    else if (res == 4)
    {
        result = TextEntryResultCorr;
    }
    else if (res == 10)
    {
        result = TextEntryResultFK1;
    }
    else if (res == 11)
    {
        result = TextEntryResultFK2;
    }
    else if (res == 12)
    {
        result = TextEntryResultFK3;
    }
    else if (res == 13)
    {
        result = TextEntryResultFK4;
    }
    
    [[VFCardReader control] keypadBeepEnabled:NO];
    [[VFCardReader control] keypadEnabled:NO];
    NSLog(@"Message Result %d", res);
    
    finishblock(result);
}

@end
