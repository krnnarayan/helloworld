//
//  VerifoneCardReaderAdapter.h
//  HelloCordova
//
//  Created by MA-MAC032 on 8/1/16.
//
//


#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import <VMF/VMFramework.h>
#import "HWCardReaderAdapter.h"

extern const NSString * kDeviceAdapterName_VFICardReader;

#define STATE_INIT -1
#define STATE_DISCONNECTED 0
#define STATE_BUSY 1
#define STATE_CONNECTED 10

typedef enum
{
    SS_HW_INIT = 0,
    SS_HW_BUSY,
    SS_HW_CONNECTED,
    SS_HW_DISCONNECTED,
    SS_HW_CHANGE_STATE,
    SS_HW_CHANGE_BARCODE,
    SS_HW_CHANGE_READER,
} SCAN_SWIPE_HW;


@interface HardwareInfo : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSString * hardwareVersion;
@property (nonatomic, retain) NSString * softwareVersion;
@property (nonatomic, retain) NSString * engineClassName;
@property (nonatomic, assign) int        state;
@property (nonatomic, assign) int        changeReason;
@property (nonatomic, assign) BOOL       barcodeConnected;
@property (nonatomic, assign) BOOL       readerConnected;

@end

@interface ReaderData : NSObject

@property (nonatomic, retain) NSString * pan;
@property (nonatomic, retain) NSString * track1;
@property (nonatomic, retain) NSString * track2;
@property (nonatomic, retain) NSString * track3;
@property (nonatomic, retain) NSString * cardNumber;
@property (nonatomic, retain) NSString * nameOnCard;
@property (nonatomic, assign) NSInteger  expMonth;
@property (nonatomic, assign) NSInteger  expYear;
@property (nonatomic, assign) BOOL       parsed;
@property (nonatomic, assign) NSDictionary* extraInfo;
@property (nonatomic, retain) HardwareInfo* hardwareInfo;
@property (nonatomic, assign) BOOL contactless;

@end

@interface PinEntryResult : NSObject
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSString *ksn;
@end

typedef void (^SuccessPinEntryBlock)(PinEntryResult *result);
typedef void (^FailPinEntryBlock)(NSError* errorMessage);

@interface CardEntryResult : NSObject
@property (nonatomic, strong) NSString *track1;
@property (nonatomic, strong) NSString *track2;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *expirationDate;
@end

typedef void (^SuccessCardEntryBlock)(ReaderData *result);
typedef void (^FailCardEntryBlock)(NSError* error);


typedef NS_ENUM(NSInteger, TextEntryResult)
{
    TextEntryResultInvalid = -1,
    TextEntryResultOK = 0,
    TextEntryResultUnseccussful,
    TextEntryResultTimeOut,
    TextEntryResultCancel,
    TextEntryResultCorr,
    TextEntryResultFK1,
    TextEntryResultFK2,
    TextEntryResultFK3,
    TextEntryResultFK4
};

typedef void (^TextEntryFinishBlock)(TextEntryResult result);



@interface VerifoneCardReaderAdapter : HWCardReaderAdapter <VFIPinpadDelegate, VFIControlDelegate>
{
    NSString * pkiCert;
    NSString * pkiID;
    NSDictionary* lookups;
    BOOL scanEnabled;
    BOOL msrEnabled;
    
    BOOL bcInit;
    bool controlInit;
    bool pinpadInit;
    
    bool bcConnected;
    bool ctlConnected;
    bool pinConnected;
    
    bool timeoutFlag;
    int _state;
    bool _ranCheckDigit;
    bool _injectedPKI;
    int _encryptionMode;
    bool _encryptionOn;
    
    HardwareInfo* _hardwareInfo;
}

//@property (nonatomic, retain) VFIPinpad *pinpad;
@property (nonatomic, retain) VFIControl *control;

@property (nonatomic, retain) NSString *pkiCert;
@property (nonatomic, retain) NSString *pkiID;

//- (void)closeVerifone;
//- (double) xpiVersion;
//- (BOOL)isPinpadConnected;
//- (void)forceEnablePinpad;
//- (void)requestPinEntry:(NSString *)pan withSuccessBlock:(SuccessPinEntryBlock)successBlock andFailBlock:(FailPinEntryBlock)failBlock;
//- (void)requestCardEntryWithAmount:(NSInteger)amount withSuccessBlock:(SuccessCardEntryBlock)successBlock andFailBlock:(FailCardEntryBlock)failBlock;
//- (void)requestCardEntryWithSuccessBlock:(SuccessCardEntryBlock)successBlock andFailBlock:(FailCardEntryBlock)failBlock;
//- (void)abortCurrectPinpadOperation;
//- (void)requestTextEntryWithPrompts:(NSArray*)promptLines choices:(NSArray*)choices andFinishBlock:(TextEntryFinishBlock)finishblock;
@end




