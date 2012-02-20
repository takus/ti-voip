/**
 * 2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.
 * License: Apache License 2.0
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import "VoiceOutput.h"

#import "TiModule.h"

@interface MeTakusTiVoipModule : TiModule
{
    VoiceOutput *output;
}

@property (retain)VoiceOutput *output;

-(id)create:(id)args;

-(void)start:(id)args;
-(void)stop:(id)args;

@end