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

@synthesize queue;

@synthesize socket;
@synthesize tag;

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        NSLog(@" new VoiceOutput:%@", self);
        self.queue = [[NSMutableArray alloc] init];
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
 
    [self.queue release];
    
    [self.socket close];
    [self.socket release];
    
	[super dealloc];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@" didReceiveData %d", [self.queue count]);
    
    // write raw data to queue
    id storeData = [[NSData alloc] initWithData:data];
    [self.queue addObject:storeData];
    
    return YES;
}

static void outputCallback(void *                  inUserData,
                           AudioQueueRef           inAQ,
                           AudioQueueBufferRef     inBuffer)
{
    VoiceOutput *output = (VoiceOutput*)inUserData;
    NSLog(@" outputCallback %d", [output.queue count]);
    
    int sleep = 0;
    while ([output.queue count] == 0)
    {
        [NSThread sleepForTimeInterval:0.1];
        sleep++;
        NSLog(@" sleep %f times", sleep * 0.1);
    }
    
    // copy first element of buffer to inBuffer
    NSData *data = (NSData *)[output.queue objectAtIndex:0];
    // TODO memcpy is not working correctly?
    memcpy(inBuffer->mAudioData, data, [data length]);
    [output.queue removeObjectAtIndex:0];
    
    inBuffer->mAudioDataByteSize = [data length];
    
    // enqueue inBuffer
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

-(void)prepareAudioQueue{
    AudioStreamBasicDescription audioFormat;
    
    audioFormat.mSampleRate			= 8000.0;
    audioFormat.mFormatID			= kAudioFormatULaw;
    audioFormat.mFormatFlags        = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked;
    audioFormat.mBytesPerPacket		= 1;
    audioFormat.mFramesPerPacket	= 1;
    audioFormat.mBytesPerFrame		= 1;
    audioFormat.mChannelsPerFrame	= 1;
    audioFormat.mBitsPerChannel		= 16;
    audioFormat.mReserved			= 0;
    
    AudioQueueNewOutput(&audioFormat,
                        outputCallback,
                        self,
                        NULL,NULL,0,
                        &audioQueueObject);

    AudioQueueBufferRef buffers[3];
    
    UInt32 numPacketsToRead = 160;
    UInt32 bufferByteSize = numPacketsToRead * audioFormat.mBytesPerPacket;
    
    int bufferIndex;
    for (bufferIndex = 0; bufferIndex < 3; bufferIndex++){
        AudioQueueAllocateBuffer(audioQueueObject,
                                 bufferByteSize,
                                 &buffers[bufferIndex]);
        outputCallback(self, audioQueueObject, buffers[bufferIndex]);
    }    
}

-(void)start
{
    [self prepareAudioQueue];
    
    AudioQueueStart(audioQueueObject, NULL);
}

-(void)stop
{
    AudioQueueStop(audioQueueObject, YES);
    AudioQueueDispose(audioQueueObject, YES);
}

@end
