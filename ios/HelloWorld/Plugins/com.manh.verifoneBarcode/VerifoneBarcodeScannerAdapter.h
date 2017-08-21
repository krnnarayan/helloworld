//
//  VerifoneBarcodeScannerAdapter.h
//  HelloCordova
//
//  Created by Alex on 2016-06-29.
//
//

#import "HWBarcodeScannerAdapter.h"
#import <VMF/VMFramework.h>

extern const NSString * kDeviceAdapterName_VFIBarcodeScanner;

@interface VerifoneBarcodeScannerAdapter : HWBarcodeScannerAdapter<VFIBarcodeDelegate, VFIPinpadDelegate, VFIControlDelegate>
{

}

@property (nonatomic, assign) BOOL isInitialized;
@property (nonatomic, strong) NSString *barcodeScannerRestartCallbackID;


@end
