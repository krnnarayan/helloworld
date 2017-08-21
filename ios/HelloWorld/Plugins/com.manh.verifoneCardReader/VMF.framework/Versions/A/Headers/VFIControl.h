


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import	<ExternalAccessory/ExternalAccessory.h>
#import "VFISoftwareVersion.h"
#import "VFIKeypadVersion.h"
#import "VFIAccessoryMgr.h"
#import "VFIStream.h"
#import "VFIGen3DeviceInfo.h"
#include "VFI_unzip.h"
#import "VFI_NSData+Base64Additions.h"

/** Protocol methods established for VFIControl class **/
@protocol VFIControlDelegate <NSObject>

@optional
- (void) controlLogEntry:(NSString*)logEntry withSeverity:(int)severity; //!<When VFIControl::logEnabled: is passed <c>TRUE</c>, this delegate will receive log entries.
//!< @param logEntry The log entry
//!< @param severity The severitry of the log entry, with 0 indicating highest priority


- (void) controlInitialized:(BOOL)isInitialized;//!<Notifies of initialization state changes in e210/e255/e315 Control Application
//!< @param isInitialized Device initialization state change
//!<- <c>TRUE</c> successfully initialized the control application,
//!<- <c>FALSE</c> control application went offline.

- (void) controlReconnectStarted;//!<When the External Accessory reports the control application is detected (but not initialized by framework),this delegate is called. This signifies the beginning of the framework initialization proess of the control application.

- (void) controlReconnectFinished;//!<This signifies the end of the framework initialization process for control application.

- (void) controlConnected:(BOOL)isConnected;//!<Notified of control connection/disconnection events.  A connect/disconnect can either be from a physical disconnection/connection with the External Accessory API, or from an application going to backround or returning to foreground.
//!< @param isConnected A new connection or disconnection was detected
//!<- <c>TRUE</c> The control application has connected.
//!<- <c>FALSE</c> The control application has disconnected.

- (void) controlSerialData:(NSData*)data  incoming:(BOOL)isIncoming; //!<All incoming/outgoing data going to the control application can be monitored through this delegate.
//!< @param data The serial data represented as a NSData object
//!< @param isIncoming The direction of the data
//!<- <c>TRUE</c> specifies data being received from control application,
//!<- <c>FALSE</c> indicates data being sent to control application.

- (void) controlDataReceived:(NSData*)data;//!<This delegate monitors all data received from Control Application.
//!< @param data A NSData binary object representing the incoming data from the control application.

- (void) controlDataSent:(NSData*)data;//!<This delegate monitors all data sent from Control Application.
//!< @param data A NSData binary object representing the outgoing data sent the control application.

- (void) controlBatteryLevel:(int)batteryLevel;
//!< @param batteryLevel A integer representing the battery level after calling @see queryBatteryLevel().

- (void) controlSoftwareVersion:(VFISoftwareVersion*)softwareVersion;
//!< @param softwareVersion VFISoftwareVersion() representing the software version after calling querySoftwareVersion().

- (void) controlKeypadVersion:(VFIKeypadVersion*)keypadVersion;
//!< @param keypadVersion VFIKeypadVersion() representing the keypad version after calling queryKeypadVersion().
- (void) controlBatteryEvent:(int)batteryLevel batteryEvent:(bool)isLowBatteryEvent;
//!<Returns battery notification events if enabled. @see enableLowBatteryNotification() to enable these events. Events fire after the OS checks the battery level, which is every 10% or when external power is attached/removed. At 10% power remaining, a special low battery notification is sent, indicated by the isLowBatteryEvent flag.
//!< @param batteryLevel Integer value of battery percentage between 0 and 100.
//!< @param isLowBatteryEvent Indicates the type of event
//!<- <c>TRUE</c> specific low power event that fires at 10% remaining power
//!<- <c>FALSE</c> indicates that this is regular power event, either user specified level or device is unplugged/plugged in

- (void) controlDownloadInfo:(NSString*)log;//!<Receives informational messages during process of downloading data to gen3 .
//!< @param log Message generated by framework during the download process to either signify status or error at various stages

- (void) controlDownloadBlocks:(int)TotalBlocks sent:(int)BlocksSent;//!<Receives transferred data statistics while downloading data to gen3
//!< @param TotalBlocks Total file size being transferred
//!< @param BlocksSent Amount of data successfully sent
@end

/**
 * POWER_STATUS structure.
 *
 * Structure to hold IAP Manager power status returned from getPowerStatus().
 */
typedef struct {
    bool HOST_PWR;                //!<On Battery Power
    bool EXT_PWR;                 //!<On External Power
    bool POWERSHARE_ON;           //!<Power Share Currently Active
    bool DATA_SYNC_EN;            //!<Data Sync is enabled
    bool IDEVICE_PRESENT;         //!<iDevice is connected to terminal
    bool GANG_CHARGER;            //!<terminal on gang charger
}POWER_STATUS;

/*
 * VMF Generated Result Code Responses
 * These response codes are used to represent the results of the updateFromZip:/updateFromURL: commands
 */
typedef enum {
    VFDownloadResult_Framework_Timeout = -1,           //!<Command never received reply to command sent. XPI is unresponsive.
	VFDownloadResult_ACK_Timeout = -2,                 //!<Command never received `<ACK>` of command sent. XPI is unresponsive.
	VFDownloadResult_Framework_Invalid_Data = -3,      //!<Data passed to method is out of bounds or invalid
	VFDownloadResult_Framework_Invalid_Length = -4,    //!<Length of data passed is out of bounds or invalid
	VFDownloadResult_Device_Not_Available = -5,        //!<value returned when command was sent when device was offline
    VFDownloadResult_Command_Write_Error = -6,         //!<Command returned write error
    VFDownloadResult_Command_Successful = 0,           //!<Download and transfer of files was successful
    VFDownloadResult_Command_Unsuccessful = 1,         //!<Download and transfer of files failed, generic error, see documentation
    VFDownloadResult_Download_Unsuccessful = 2,        //!<Download of files failed, Check network connection
    VFDownloadResult_Transfer_Unsuccessful = 3,        //!<Transfer of downloaded files to sled failed
    VFDownloadResult_Invalid_Zip_Archive = 4,          //!<Zip file provided is not valid or is corrupted
    VFDownloadResult_Missing_CRT_File = 5,             //!<Zip file provided is missing the Signer Cert File
    VFDownloadResult_Missing_P7S_File = 6,             //!<Zip file provided is missing the P7S Signature File
    VFDownloadResult_Missing_ZIP_File = 7,             //!<Zip file provided is missing the zip file
    VFDownloadResult_Authentication_Error = 8,         //!<Zip loaded successfully but authentication of signature failed
} VFDownloadResult;

/**
 * API methods for e210/e255/e315 Pinpad Control.
 *
 * Implementing this class will allow access to API calls that will perform e210/e255/e315 Pinpad control, such as keypad beep on or off.
 */
@interface VFIControl : NSObject < EAAccessoryDelegate, NSStreamDelegate,UIApplicationDelegate> {
	
	id <VFIControlDelegate> delegate;
    
    
}
/**
 * Creates an instance of VFIControl class.
 *
 * @retval <id> of VFIControl class
 *
 * Example Usage:
 * @code
 *    VFIControl* control = [[VFIControl alloc] init];
 * @endcode
 */

-(id)init;

/**
 * Initializes the control application.
 *
 * This is executed after the instance is created with init. If any of the optional protocols will be used, setDelegate should first be executed.
 *
 * Example Usage:
 * @code
 *    VFIControl* control = [[VFIControl alloc] init];
 *    [control setDelegate:self];
 *    [control initDevice];
 * @endcode
 */
-(void) initDevice;
/*
 * Initializes the control application via a remote socket connection. The initial connection must have already been established through VFIPinpad initDeviceOnServer:(NSString*)address port:(int)port
 *
 * This is executed after the instance is created with init. If any of the optional protocols will be used, setDelegate should first be executed.
 *
 * Example Usage:
 * @code
 *    VFIControl* control = [[VFIControl alloc] init];
 *    [control setDelegate:self];
 *    [control initDevice];
 * @endcode
 */
-(void) initDeviceOnServer;
/**
 * Terminates stream connection to Control application
 *
 * This method will shut down the connection to the Control stream. An initDevice() will need to be executed again to engage a new stream connection.
 */
-(void) closeDevice;

/**
 * Send a string command to Control application
 *
 * Sends a command represented by the provide string object to the control application through the accessory protocol.
 *
 * @param cmd NSString representation of command to execute
 */
-(void) sendCommand:(NSString*)cmd;

/**
 * Send a string command to Control application
 *
 * Sends a command represented by the provide command string to the control application through the accessory protocol. An LRC is calculated and appended to the command string sent.
 *
 * @param cmd NSString representation of command to execute
 */
-(void) sendCommandLRC:(NSString*)cmd;

/**
 * API method to disable keypad when USB power is plugged in.
 *
 * @param isDisabled
 * - <c>TRUE</c> Disable keypad on USB Power
 * - <c>FALSE</c> Enable keypad on USB Power
 */
-(void) disableKeypadOnUSBPower:(BOOL)isDisabled;

/**
 * API method to enable or disable the keypad.
 *
 * @param isEnabled
 * - <c>TRUE</c> Enable keypad
 * - <c>FALSE</c> Disable keypad
 */
-(void) keypadEnabled:(BOOL)isEnabled;

/**
 * API method to enable or disable the iOS device charging from e210 battery.
 * Command does not work on Gen3
 *
 * @param isEnabled
 * - <c>TRUE</c> iOS device will use e210 to charge internal iOS battery.
 * - <c>FALSE</c> iOS device will NOT use e210 to charge internal iOS battery.
 */
-(void) hostPowerEnabled:(BOOL)isEnabled;

/**
 * Power Share Enabled
 * This command is only implemented on e315/e335. If TRUE, command enables the iPod to draw power from the internal battery.
 * If power sharing is not permitted, an iPod is not connected or accessory power is applied, the command will return false
 *
 * @param isEnabled
 * - <c>TRUE</c> iOS device will draw power from e315/e335 battery.
 * - <c>FALSE</c> iOS device will NOT draw power from e315/e335 to charge battery.
 */
-(bool) powerShareEnabled:(BOOL)isEnabled;


/**
 * API method to enable or disable the keypad beep that sounds whenever a key is pressed on the e210/e255/e315 PINPad.
 *
 * @param isEnabled
 * - <c>TRUE</c> Enable beep
 * - <c>FALSE</c> Disable beep
 */
-(void) keypadBeepEnabled:(BOOL)isEnabled;

/**
 * API method to power down e210/e255/e315.
 */
-(void) powerDown;

/**
 * Queries e210/e255/e315 for current battery level.  Result in battery percentage 0-100 stored in VFIControl property batteryLevel()
 */
-(void) queryBatteryLevel;

/**
 * Queries e210/e255/e315 for current control software version.  Result as VFISoftwareVersion stored in VFIControl property vfiSoftwareVersion()
 */
-(void) querySoftwareVersion;

/**
 * Queries e210/e255/e315 for current e210/e255/e315 keypad version.  Result as VFIKeypadVersion stored in VFIControl property vfiKeypadVersion()
 */
-(void) queryKeypadVersion;

/**
 Get Keypad State
 
 * Queries e210/e255/e315 for current keypad state.  Result as returned as a two-digit NSString
 
 @retval 2 Digit Code for Keypad State- Enable_State-Beep_State
 - Enable_State: 0 if keypad is disabled, 1 if keypad is enabled and awake, 2 if keypad is enabled, but still waking up.
 - Beep_State: 0 if beeps are disabled, 1 if beeps are enabled.
 
 Example, "10" is keypad enabled, beeps disabled.
 */
-(NSString*) getKeypadState;

/**
 Get Bluetooth Firmware Version
 
 * Queries e255 to read the firmware version of the Bluetooth module.
 
 @retval An ASCII string containing the version information.
 */
-(NSString*) getBTFirmwareVersion;

/**
 Get Bluetooth Friendly Name
 
 This command allows the phone to read the friendly name of the Bluetooth module. The friendly name is the name that is displayed when discovering and pairing to e255. Use the *BT_NAME variable to change the name.
 
 @retval An ASCII string containing the friendly name.
 */
-(NSString*) getBTFriendlyName;

/**
 Get Bluetooth PIN
 
 This command allows the phone to read the PIN number of the Bluetooth module. The pin number may not be required when Secure Simple Pairing is enabled. Use the *BT_PIN variable to change the PIN.
 
 @retval A 4 digit numeric ASCII PIN number string.
 */
-(NSString*) getBTPIN;

/**
 Reboot Device
 
 This command reboots the Verix OS.
 
 */
-(void) rebootDevice;


/**
 Get Gen3 Device Info
 
 This command returns a comma separated list of information fields for the Gen3 device. Note that some of the response properties will be deprecated in future updates.
 
 Data returned from command will be stored in VFIGen3DeviceInfo object
 
 */
-(void) getGen3DeviceInfo;

/**
 Get KSI
 
 This command returns the KSI fields of the keys in the 3 DUKPT engines of the IPP.
 
 @retval Three comma separated ASCII hex fields. if no key is injected in that space, there will be no bytes returned. Commas will always be present.
 */
-(NSString*) getKSIVersion;

/**
 Set Device Logging Status
 *
 * This command will enable and disable logging on the Gen3 device.
 *
 * @param isEnabled
 * - <c>TRUE</c> Enable device logging
 * - <c>FALSE</c> Disable device logging
 *
 * @retval TRUE = Command success, FALSE = Command failure
 */
-(bool) setDeviceLogging:(bool)isEnabled;

/**
 Get Device Logging Status
 *
 * This command will return the logging status on the Gen3 device.
 *
 * @retval An integer denoting the response. 1 = ENABLED, 0 = DISABLED, -1 = ERROR
 */
-(int) queryDeviceLogging;

/**
 Get Log Record
 
 This command retrieves one log record at a time from a Gen3 device.
 
 @retval A string containing a log record. If no record found, returns blank string.
 */
-(NSString*) getLogRecord;

/**
 Get Crash Info
 
 This command retrieves system crash info from a Gen3 device.
 
 @retval A string containing crash info
 */
-(NSString*) getCrashInfo;

/**
 * Enable Low Battery Notification
 *
 *  This command can enable and disable an asynchronous message from a Gen3 device to alert the application that the battery has reached a certain power threshold.
 *  This command will force the notification to only be returned at the 10% power level. The notification is asynchronous and will return in the controlBatteryEvent Delegate.
 *
 *  Note: You must be connected to the Control channel in order to receive this notification.
 *
 * @param isEnabled
 * - <c>TRUE</c> Enable low battery notification
 * - <c>FALSE</c> Disable low battery notification
 *
 * @retval TRUE = Enabled, FALSE = Error
 */
-(bool) enableLowBatteryNotification:(bool)isEnabled;

/**
 * Enable Low Battery Notification
 *
 *  This command can enable and disable an asynchronous message from a Gen3 device to alert the application that the battery has reached a certain power threshold.
 *  This command allows the integrator to provide a specific battery level for the low power event to fire at.
 *  Additionally, the notification will also fire at the 10% level as a specific low power indication.
 *  The notification is asynchronous and will return in the controlBatteryEvent Delegate.
 *
 *  Note: You must be connected to the Control channel in order to receive this notification.
 *
 * @param isEnabled
 * - <c>TRUE</c> Enable low battery notification
 * - <c>FALSE</c> Disable low battery notification
 * @param notificationLevel An integer to specify what battery level you would like the custom low battery event to fire at. Allowed values are 1-99.
 *
 * @retval TRUE = Enabled, FALSE = Error
 */
-(bool) enableLowBatteryNotification:(bool)isEnabled withNotificationLevel:(int)notificationLevel;

/**
 Perform MSR Diagnostics
 *
 *  This command returns status of MSR swipe and also each track status and number of bytes of track data. This command will timeout after 10 seconds.
 *
 *   @retval Good response is in ASCII hex format string. Bad response returns 'ERR' string. Timeout reached returns '-1' string.
 */
-(NSString*) performMSRDiagnostic;

/**
 Perform PIN Entry Diagnostic
 
 This command prompts the user to tap 4 keys on Gen3 keypad and display success on LCD screen when 4 key entries are detected. Otherwise displays failed message.
 
 @retval A 12 byte string containing keypad firmware version
 */
-(NSString*) performPINEntryDiagnostic;

/**
 Perform Keypad All Key Diagnostic
 
 This command prompts user to tap all keys on Gen3 keypad and display sucess on LCD screen when all key entries are detected. Otherwise displays failed message.
 
 @retval TRUE = Success, FALSE = Failure
 */
-(bool) performKeypadAllKeyDiagnostic;

/**
 Perform Display Diagnostic
 
 This command tests display of Gen3 device by inverting all pixels for a few seconds.
 
 @retval TRUE = Success, FALSE = Failed to open console device
 */
-(bool) performDisplayDiagnostic;

/**
 Start Diagnostic Mode
 
 This command displays diagnostic mode message on Gen3 LCD and sets the diagnostic flag.
 
 @retval TRUE = Device is in Diagnostic Mode, FALSE = Error enabling diagnostic mode.
 */
-(bool) startDiagnosticMode;

/**
 Stop Diagnostic Mode
 
 This command exits diagnostic mode on the Gen3 and clears diagnostic mode flag. This command always returns OK response.
 */
-(void) stopDiagnosticMode;

/**
 *   Set Date And Time
 *
 *   This command sets date and time of Gen3. Date and time should be given in NSDate format and year must be in the range 1990 to 2089.
 *
 * @param date
 * - <c>NSDate*</c>
 *
 * @retval TRUE = Set date successfully, FALSE = incorrect date/time was requested
 */
-(bool) setDateAndTime:(NSDate*)date;

/**
 * Get File Hash
 *
 * This command gets a SHA-256 hash of a given file on the Gen3 device.
 *
 * @param filePath
 * - filePath is an ASCII string containing the path for the Verix file.
 *
 * @retval NSString with hash value or ERR if failed.
 */
-(NSString*) getFileHash:(NSString*)filePath;

/**
 * Set Contactless LED
 *
 * This command enables the LEDs of a gen3 device for use with contactless payments. Send a string of four bytes to determine which LEDs should be enabled or disabled. Send "0000" to turn off all LEDs and "1111" to turn on all LEDs.
 *
 * @param enableLED is a string of four bytes that determines which LEDs should be on or off.
 *
 * @retval TRUE = Success, FALSE = Failed to set LEDs
 */
-(bool) setContactlessLED:(NSString*)enableLEDString;

/**
 * Host Device Charging in e335
 *
 * This command gives current status of host device charging for e335 ONLY. Host charging is enabled by setting configuration variable *ENHOSTCHARGE and disabled by clearing it and followed by  enable call to hostPowerEnabled_e335. Equivalent to G54 command.
 *
 * @retval TRUE = Host Charging is Enabled, FALSE = Host Charging is Disabled
 */
-(BOOL) isHostPowerEnabled_e335;

/**
 * Enable Host Device Charging in e335
 *
 * This command will enable and disable host device charging. Host charging is enabled by setting configuration variable *ENHOSTCHARGE and disabled by clearing it. Restart required after enable and disable commands for OS to read change in configuration value. e335 Host Device Charging status can be queried via the isHostPowerEnabled_e335 command. Equivalent to G54 command.
 *
 * @param isEnabled is a boolean value to indicate if host charging should be enabled on e335.
 *
 * @retval TRUE = Command Success, FALSE = Command Failed
 */
-(BOOL) hostPowerEnabled_e335:(BOOL)isEnabled;

/**
 * iOS6 Watchdog Timer
 *
 * This command is a work-around for an iOS6 bug in which the iAP2 connection cannot be re-established after an iOS6 App crashes. The default state is that the timer is disabled. When this command arrives, it sets the timer to the given number of milliseconds and starts the timer counting down. If the timer expires, the OS re-boots. Otherwise if another command arrives before the timer expires, the timer is reset to the new number of milliseconds. The timer can be shut off by sending this command with the “OFF” parameter. The valid timer settings are from 1 millisecond to 1 day. Equivalent to G51 command.
 *
 * @param disableTimer is a boolean value to indicate if the workaround should be enabled.
 * @param countdownTimer is a user provided int that indicates the length to wait.
 *
 * @retval TRUE = Command Success, FALSE = Command Failed
 */
-(BOOL) enableWatchdogTimer:(BOOL)disableTimer withCountdownValue:(int)countdownTimer;

/**
 * Display Message
 *
 * This command displays a message to the LCD display at the given location. This command is to be used in diagnostic mode only. Equivalent to G48 command.
 *
 * @param message is a string to display at coordinates
 * @param x is the x coordinate starting with column 1
 * @param y is the y coordinate starting with column 1
 * @param clearDisplay is a boolean value to indicate whether or not the screen should be cleared.
 *
 * @retval TRUE = Command Success, FALSE = Command Failed
 */
-(BOOL) displayMessage:(NSString *)message withX:(NSString *)x andY:(NSString *)y shouldClearDisplay:(BOOL)clearDisplay;

/**
 * Diagnostic Mode Query
 *
 * This command checks whether the Gen3 is in diagnostics mode. Equivalent to G47 command.
 *
 * @retval TRUE = Device is in diagnostic mode, FALSE = Device is not in diagnostic mode
 */
-(BOOL) queryDiagnosticMode;

/**
 Get Power Status
 
 Returns IAP Manager power status.
 
 @retval A POWER_STATUS structure populated with IAP Manager Power Status.
 */
-(POWER_STATUS) getPowerStatus;
/**
 Get Bluetooth SPP Enable
 
 This command allows the phone to read the enable state of the Secure Simple Pairing mode in the Bluetooth module. Enabling SSP allows some devices to pair to e255 without a PIN number. Some devices require SSP to be disabled in order to pair. Use the *BT_SSP_EN variable to change the setting.
 
 @retval TRUE = SPP Enabled, FALSE = SPP Disabled
 */
-(BOOL) getBTSPPEnable;


/**
 * Enabled logging to XCode Console.
 *
 * @param enable Setting \a TRUE enables additional logging to debug console window in iOS
 */
-(void) consoleEnabled:(BOOL)enable;

/**
 * Enabled logging to delegate.
 *
 * @param enable Setting \a TRUE enables logging to VFIControlDelegate::controlLogEntry:withSeverity:()
 */
-(void) logEnabled:(BOOL)enable;

/**
 * Controls the restart loop delay
 *
 * @param sec The amount of time in fractional sections to wait between attempts in establishing contact to e210/e255/e315 while waiting for initialization
 *
 * Default is 1.0 seconds.
 */
-(void) restartLoopDelay:(float)sec;

/**
 * Controls the amount of looping attempts to contact control application.
 *
 * @param loop The number of loops in establishing contact to e210/e255/e315 while waiting for initialization
 *
 * If the e210/e255/e315 is unresponsive, the framework will loop the specified number of times, with a delay of restartLoopDelay:() between each attempt. The default is 59 loops.
 */
-(void) setInitLoop:(int) loop;
/**
 * Renables default blocking on all API methods
 *
 * By default blocking is on. Most API calls will wait for a response from Control app before returning control to integrator.  This behavior can be turned off by calling disableBlocking()
 */
-(void) enableBlocking;

/**
 * Disables default blocking on all API methods
 *
 * By default blocking is on. Most API calls will wait for a response from Control app before returning control to integrator.  This behavior can be turned off by calling this method.  Default blocking can be turned back on by calling enableBlocking()
 */
-(void) disableBlocking;

/**
 * Get Power Mode
 *
 * This command returns the state of “Enable Host Power”.
 
 * @retval Power Mode:
 * - FALSE: Power to host device disabled
 * - TRUE: Host power enabled
 */
-(bool) isHostPowerEnabled;

/**
 * Update From Zip
 *
 * Updates the e315/e335/e355 with a properly created archive compressed as a .zip archive.
 * Note: Gen3 ONLY
 *
 * @param data The .zip archive containing data to transfer into e315/e335/e355
 *
 * @code
 * NSFileManager *fm;
 * fm = [NSFileManager defaultManager];
 * NSString *documentsDirectory = [[NSBundle mainBundle] resourcePath];
 * NSString* currentFile = [[NSString alloc] initWithFormat:@"%@/%@",documentsDirectory,@"DEMO-20150101.zip"];
 * NSData* dt = [[NSData alloc] initWithContentsOfFile:currentFile];
 * [control updateFromZip:dt];
 * @endcode
 */
-(VFDownloadResult) updateFromZip:(NSData*)zipData;

/**
 * Update From URL
 *
 * Updates the e315/e335/e355 with a properly created archive compressed as a .zip archive.
 * Note: Gen3 ONLY
 *
 * @param theURL An NSString that contains the URL of the update file for download
 * Note: URL String MUST end in .zip, no redirect URLs are allowed
 *
 * @code
 * [control updateFromURL:@"https://dl.dropboxusercontent.com/u/100061160/UPDATE.zip"];
 * @endcode
 */
-(VFDownloadResult) updateFromUrl:(NSString*)theURL;

/**
 * Ping Command
 *
 * This command is for pinging (send & receive the same data back). When a valid message is properly received prior to the message being processed an ACK/NAK is transmitted back to the requesting device. With Bluetooth , there is a chance that the ACK response will be transmitted just before the PING payload buffer and be wrapped together in the same Frame when received by the e355. The requesting app should take this into account when validating the PING payload.
 *
 * @param payload An NSString that is sent to the terminal. If the Control app is responsive, you will get the payload returned.
 *
 * @retval An NSString that should be the same as your payload NSString. When done over Bluetooth, you may receive an ACK character before the Payload, due to the nature of BT.
 */
-(NSString *) pingControlApp:(NSString*)payload;

/**
 * Page Command
 *
 * This command is for paging the connected Terminal. If configured, this command will flash the barcode scanner, the backlight and also make the device beep for the amount of time provided.
 *
 * @param duration An integer value from 1 - 999 that determines how long the terminal will react to this command. Default is 10 seconds.
 * @param barcode If True, barcode will flash
 * @param backlight If True, screen will flash
 * @param beep If True, terminal will beep
 *
 */
-(void) pageSledForDuration:(int)duration useBarcode:(BOOL)barcode useBackLight:(BOOL)backlight useBeep:(BOOL)beep;

/**
 * Get ADE Status
 *
 * This command provides the status of whether ADE is active or not. ADE is active when feature enable license of ADE is enabled and at least one key of ADE exists in the unit.
 *
 * @retval NSString A two-digit NSString representative of the status, in the following format:
 * @retval Left-most-digit - 0 indicates ADE is not supported and 1 indicates supported.
 * @retval Right-most-digit - 0 indicates ADE is inactive and 1 indicates ADE is active.
 * @retval Error If this commands fails or is unsupported on the device, it will return a 99 response.
 *
 */
-(NSString *) getADEStatus;

/**
 * Get Time Since Last Reboot
 *
 * This command returns time in milliseconds that informs elapsed time since the e355 terminal was powered up or restarted. PCI4 requirement forces the terminal to restart at every 24HRS and this command can be used for tracking the next PCI4 restart.
 *
 * @retval An NSString that provides the up-time (time since last reboot) in milliseconds
 *
 */
-(NSString *) getTimeSinceLastReboot;

/**
 * Get Self-Test Restart Time
 *
 * This command returns the set time to perform the self-test. Self-test is a PCI4 requirement to authenticate code and key files every 24 hours. e355 will be restarted at this set time to complete the test.
 *
 * @retval An NSString that returns the self-test time in HHMM format.
 */
-(NSString *) getSelfTestRestartTime;

/**
 * Set Self-Test Restart Time
 *
 * This command sets self-test time. Self-test is a PCI4 requirement to authenticate code and key files every 24 hours, e355 will be restarted at this set time for completing self-test. If parameters HH and MM are specified then self-test time is set to HH hour and MM minute.
 *
 * @param HHMM This is an NSString that is representative of the proposed self-test reboot time. Format should be HHMM, such as @"2230" for 10:30PM
 *
 * @retval BOOL True if the command successfully set the time, False if there was an error
 *
 */
-(BOOL) setSelfTestRestartTime:(NSString*)HHMM;

/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
-(void)processReceivedData:(NSData*)data;
/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
+ (VFIControl *)sharedController;

/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
-(void) ignoreDisconnect;

/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
-(void) disableProtocol:(BOOL)disable;
/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
- (void) sendData:(NSData*)data;

#if !__has_feature(objc_arc)
@property (retain) id<VFIControlDelegate>  delegate;                //!< Gets or Sets delegate for protocols
#else
@property (strong) id<VFIControlDelegate> delegate;
#endif
@property (nonatomic, readonly) NSString *controlName;              //!< Read Only name reported to External Accessory
@property (nonatomic, readonly) NSString *controlManufacturer;      //!< Read Only Manufacturer reported to External Accessory
@property (nonatomic, readonly) NSString *controlModelNumber;       //!< Read Only Model Number reported to External Accessory
@property (nonatomic, readonly) NSString *controlSerialNumber;      //!< Read Only Serial Number reported to ExternalExternal AccessoryAccessory
@property (nonatomic, readonly) NSString *controlFirmwareRevision;  //!< Read Only Firmware Version reported to External Accessory
@property (nonatomic, readonly) NSString *controlHardwareRevision;  //!< Read Only Hardware Version reported to External Accessory
@property (readonly) int batteryLevel;                              //!< contains result after running VFIControl::queryBatteryLevel
@property (readonly) BOOL controlConnected;                         //!< Read Only Boolean control connection status
@property (readonly) BOOL connected;                                //!< Read Only Boolean control connection status
@property (nonatomic, readonly) EAAccessory *eaACC;                 //!< Read Only Connected Accessory
@property (readonly) BOOL BTconnected;                              //!< Read Only Boolean barcode e210/e255/e315 Bluetooth connection Status
#if !__has_feature(objc_arc)
@property (nonatomic, retain) VFISoftwareVersion *vfiSoftwareVersion;//!< contains result after running VFIControl::querySoftwareVersion
@property (nonatomic, retain) VFIKeypadVersion *vfiKeypadVersion;   //!< contains result after running VFIControl::queryKeypadVersion
@property (nonatomic, retain) VFIGen3DeviceInfo *vfiGen3DeviceInfo;  //!< Holds results from G25-getGen3DeviceInfo command
#else
@property (nonatomic, strong) VFISoftwareVersion *vfiSoftwareVersion;//!< contains result after running VFIControl::querySoftwareVersion
@property (nonatomic, strong) VFIKeypadVersion *vfiKeypadVersion;   //!< contains result after running VFIControl::queryKeypadVersion
@property (nonatomic, strong) VFIGen3DeviceInfo *vfiGen3DeviceInfo;  //!< Holds results from G25-getGen3DeviceInfo command
#endif
@property (readonly) BOOL initialized;                              //!< Read Only Boolean control initialized
@property (readonly) BOOL isGen3;                                   //!< Read Only Boolean Gen3 Connected




@end

