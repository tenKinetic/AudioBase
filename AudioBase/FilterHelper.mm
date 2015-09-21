//
//  FilterHelper.m
//  AudioBase
//
//  Created by Chris Saunders on 2/09/2015.
//  Copyright (c) 2015 tenKinetic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FilterHelper.h"

#import "Novocaine.h"
#import "RingBuffer.h"
#import "NVLowpassFilter.h"
#import "NVHighpassFilter.h"
#include <vector>

@interface FilterHelper()
{
    std::vector<std::pair<double, double>> probabilityFrequencies;
    NSMutableArray *freqArray;
    Novocaine *audioManager;
    int bands;
    RingBuffer *ringBuffer;
}

@end

@implementation FilterHelper

-(id) init
{
    self = [super init];
    if (self)
    {
        ringBuffer = new RingBuffer(32768, 2);
        self->audioManager = [Novocaine audioManager];
    }
    return self;
}

-(void)startHPF
{
    // set up the filter and playthrough
    __unsafe_unretained typeof(self) weakSelf = self;
    
    // setup input block
    [self->audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    {
        float volume = 0.5;
        vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
        weakSelf->ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    }];
    
    // setup Highpass filter
    NVLowpassFilter *LPF = [[NVLowpassFilter alloc] initWithSamplingRate:audioManager.samplingRate];
    LPF.cornerFrequency = 800.0f;
    LPF.Q = 0.8f;
    
    // setup audio output block
    [self->audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels)
    {
        weakSelf->ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
        [LPF filterData:outData numFrames:numFrames numChannels:numChannels];
    }];
    
    [self->audioManager play];
}

-(void)startPassthrough
{
    __unsafe_unretained typeof(self) weakSelf = self;
    [self->audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    {
        float volume = 0.5;
        vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
        weakSelf->ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    }];


    [self->audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels)
    {
        weakSelf->ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
    }];

    [self->audioManager play];
}

-(void)stop
{
    [self->audioManager pause];
}

@end
