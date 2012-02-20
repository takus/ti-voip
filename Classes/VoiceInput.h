/**
 * 2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.
 * License: Apache License 2.0
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "GCDAsyncUdpSocket.h"

@interface VoiceInput : NSObject 
{
    AudioQueueRef audioQueueObject;
    UInt32 numPacketsToWrite;
    SInt64 startingPacketCount;
    
    GCDAsyncUdpSocket *socket;
    long tag;
    NSString *dstHost;
    NSInteger dstPort;
}

-(void)start;
-(void)stop;

-(void)prepareAudioQueue;

@property UInt32 numPacketsToWrite;
@property SInt64 startingPacketCount;

@property (retain) GCDAsyncUdpSocket *socket;
@property (retain) NSString *dstHost;
@property NSInteger dstPort;
@property long tag;

@end