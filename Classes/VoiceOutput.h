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

@interface VoiceOutput : NSObject
{
    AudioQueueRef audioQueueObject;
    
    NSMutableArray *queue;
    
    GCDAsyncUdpSocket *socket;
    long tag;
}

-(void)bind:(NSInteger)port;
-(void)start;
-(void)stop;

-(void)prepareAudioQueue;

@property (retain) NSMutableArray *queue;

@property (retain) GCDAsyncUdpSocket *socket;
@property long tag;

@end
