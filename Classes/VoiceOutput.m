/**
 * 2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.
 * License: Apache License 2.0
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import "VoiceOutput.h"

#import "GCDAsyncUdpSocket.h"

@implementation VoiceOutput

@synthesize socket;
@synthesize tag;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        NSLog(@" new VoiceOutput:%@", self);
    }
    return self;
}

-(void)bind:(NSInteger)port
{
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![self.socket bindToPort:port error:&error])
    {
        NSLog(@"[ERROR] Binding: %@", error);
        return;
    }
    if (![self.socket beginReceiving:&error])
    {
        NSLog(@"[ERROR] Receiving: %@", error);
        return;
    }
    tag = 0;

}

-(void)dealloc
{
    NSLog(@" dealloc VoiceOutput");
    
    [self.socket close];
    [self.socket release];
    
	[super dealloc];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSInteger size = [data length];
    NSLog(@" didReceiveData: %d", size);
    
    return YES;
}

-(void)start
{
    //nothing todo
}

-(void)stop
{
    //nothing todo        
}

@end
