/**
 * 2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.
 * License: Apache License 2.0
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import "MeTakusTiVoipModule.h"

#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation MeTakusTiVoipModule

@synthesize input;
@synthesize output;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"8ab25eda-7b7e-4769-9f84-faa136abd1f1";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"me.takus.ti.voip";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
    
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(YES);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
    [self.input release];
    self.input = nil;
    
    [self.output release];
    self.output = nil;
    
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

-(void)audioSesstionToPlayAndRecord
{
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, 
                            sizeof (sessionCategory), 
                            &sessionCategory);
}

#pragma Public APIs

-(id)create:(id)args
{
    self = [super init];
    if(self != nil){
        [self audioSesstionToPlayAndRecord];
    }
    return self;
}

-(void)start:(id)args
{    
    NSLog(@"[INFO] VoIP start");
    
    NSString *dstHost = [TiUtils stringValue:[args objectAtIndex: 0]];
    NSInteger dstPort = [TiUtils intValue:   [args objectAtIndex: 1]];
    NSInteger srcPort = [TiUtils intValue:   [args objectAtIndex: 2]];
    
    if ([dstHost length] == 0)
    {
        NSLog(@"[ERROR] Address required");
        return;
    }
        
    if (dstPort <= 0 || dstPort > 65535)
    {
        NSLog(@"[ERROR] Valid port required");
        return;
    }    
    
    if(self.input == nil)
    {
        self.input = [[VoiceInput alloc] init];
            
        [self.input setDstHost:dstHost];
        [self.input setDstPort:dstPort];
           
        [self.input start];
    }
    
    if(self.output == nil)
    {
        self.output = [[VoiceOutput alloc] init];
        
        [self.output bind:srcPort];
                
        [self.output start];
    }

}

-(void)stop:(id)args
{    
    NSLog(@"[INFO] VoIP stop");
    
    if (self.input != nil)
    {
        [self.input stop];
        [self.input release];
        self.input = nil;
    }
    
    if (self.output != nil)
    {
        [self.output stop];
        [self.output release];
        self.output = nil;
    }
}

@end