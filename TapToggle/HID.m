//
//  HID.m
//  TapToggle
//
//  Created by Dave Carlton on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HID.h"
#import <Foundation/Foundation.h>
#include <IOKit/hidsystem/IOHIDParameter.h>

//===========================================================================================================================
//	IOBluetoothFindNumberOfRegistryEntriesOfClassName
//===========================================================================================================================

long IOBluetoothFindNumberOfRegistryEntriesOfClassName( const char *deviceType )
{
	long			numberOfDevicesFound = 0;
	IOReturn		result;
	io_iterator_t	iterator = IO_OBJECT_NULL;
	io_object_t		obj = IO_OBJECT_NULL;
	io_object_t		parent;
	io_object_t		newParent;
	CFTypeRef		locationID = NULL;
	IOReturn		status;
	NSMutableSet *	locationIDsFound = [NSMutableSet set];
    
	CFMutableDictionaryRef matchingDict = IOServiceMatching(deviceType);
	if (matchingDict == NULL)
		return 0;
	
	result = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, &iterator);
	if (result != kIOReturnSuccess || iterator == IO_OBJECT_NULL)
		return 0;
	
	// Now counts the objects of that type:
	while ( ( obj = IOIteratorNext(iterator) ) != IO_OBJECT_NULL )
	{
		CFNumberRef numberRef = IORegistryEntryCreateCFProperty(obj, CFSTR(kIOHIDVirtualHIDevice), kCFAllocatorDefault, 0);
		if(numberRef)
		{
			BOOL virtualDevice = CFBooleanGetValue((CFBooleanRef)numberRef);
			CFRelease(numberRef);
			if(virtualDevice)
			{
				IOObjectRelease(obj);
				continue;
			}
		}
		
		parent = obj;
		status = kIOReturnSuccess;
		
		IOObjectRetain(parent);		// Retain parent (obj)
		
		while (status == kIOReturnSuccess) {
			locationID = IORegistryEntryCreateCFProperty(parent, CFSTR("LocationID"), kCFAllocatorDefault, 0);
			// Workaround for MS Device with MS driver
			if (locationID == NULL) {
				locationID = IORegistryEntryCreateCFProperty(parent, CFSTR("locationID"), kCFAllocatorDefault, 0);
			}
			
			
			if(locationID != NULL && [(__bridge NSNumber*)locationID intValue] != 0) {
				if ([locationIDsFound containsObject:(__bridge NSNumber *)locationID]) {
					status = kIOReturnExclusiveAccess;
				}
				else {
					[locationIDsFound addObject:(__bridge NSNumber *)locationID];
				}
				
				IOObjectRelease(parent);
				break;
			}
			
			status = IORegistryEntryGetParentEntry(parent, kIOServicePlane, &newParent);
			IOObjectRelease(parent);
			
			parent = newParent;
		}
		
		if (status != kIOReturnSuccess)
		{
			IOObjectRelease(obj);
			continue;
		}
		
		if ( strcmp(deviceType, "IOHIKeyboard" ) == 0 )
		{
			CFTypeRef typeRef = IORegistryEntryCreateCFProperty( obj, CFSTR( "HIDKeyboardKeysDefined" ), kCFAllocatorDefault, 0 );
			if( typeRef )
			{
				// for keyboards, make sure that it has HIDKeyboardKeysDefined on it.
                
				// also, we do not want to count IOHIDConsumer, AppleADBButtons, AppleUSBProKeyboard
				if (IOObjectConformsTo( obj , "IOHIDConsumer") || IOObjectConformsTo( obj , "AppleADBButtons") || IOObjectConformsTo( obj , "AppleUSBProKbd"))
				{
					// We do not want to do anything for this objects
				}
				else
				{							
					// We count all the other instances
					numberOfDevicesFound++;
				}
                
				CFRelease( typeRef );
			}
		}
		else // For all non keyboard devices:
		{
			// don't count consumer devices. This will include Harmon Kardon SoundSticks, and who knows what else.
			
			if( !IOObjectConformsTo( obj , "IOHIDConsumer") )
			{
				numberOfDevicesFound++;
			}
		}
        
		IOObjectRelease(obj);
	}
    
	IOObjectRelease(iterator);
    
	return( numberOfDevicesFound );
}

@implementation HID

@end
