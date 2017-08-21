#import <Foundation/Foundation.h>
#import <asl.h>

#import "VMF_VMFLog.h"

/**
 * Welcome to Cocoa Lumberjack!
 * 
 * The project page has a wealth of documentation if you have any questions.
 * https://github.com/robbiehanson/CocoaLumberjack
 * 
 * If you're new to the project you may wish to read the "Getting Started" wiki.
 * https://github.com/robbiehanson/CocoaLumberjack/wiki/GettingStarted
 * 
 * 
 * This class provides a logger for the Apple System Log facility.
 * 
 * As described in the "Getting Started" page,
 * the traditional NSLog() function directs it's output to two places:
 * 
 * - Apple System Log
 * - StdErr (if stderr is a TTY) so log statements show up in Xcode console
 * 
 * To duplicate NSLog() functionality you can simply add this logger and a tty logger.
 * However, if you instead choose to use file logging (for faster performance),
 * you may choose to use a file logger and a tty logger.
 **/

@interface VMF_DDASLLogger : VMF_DDAbstractLogger <VMFLogger>
{
	aslclient client;
}

+ (VMF_DDASLLogger *)sharedInstance;

// Inherited from VMF_DDAbstractLogger

// - (id <VMFLogFormatter>)logFormatter;
// - (void)setLogFormatter:(id <VMFLogFormatter>)formatter;

@end