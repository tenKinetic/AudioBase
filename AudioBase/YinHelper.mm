//
//  bridge.m
//  Claritone
//
//  Created by Chris Saunders on 31/08/2015.
//  Copyright (c) 2015 tenKinetic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YinHelper.h"

#import "Novocaine.h"
#import "RingBuffer.h"
#import "pYin.h"
#include <vector>

@interface YinHelper()
{
    std::vector<std::pair<double, double>> probabilityFrequencies;
    NSMutableArray *freqArray;
    Novocaine *audioManager;
    RingBuffer *ringBuffer;
}

@end

@implementation YinHelper

template<template <typename> class P = std::less >
struct compare_pair_first {
    template<class T1, class T2> bool operator()(const std::pair<T1, T2>& left, const std::pair<T1, T2>& right) {
        return P<T2>()(left.first, right.first);
    }
};

template<template <typename> class P = std::less >
struct compare_pair_second {
    template<class T1, class T2> bool operator()(const std::pair<T1, T2>& left, const std::pair<T1, T2>& right) {
        return P<T2>()(left.second, right.second);
    }
};

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

-(void)analyse
{
    // start collecting frequency data into probabilityFrequencies
    __unsafe_unretained typeof(self) weakSelf = self;
    
    // empty the vector
    probabilityFrequencies.clear();
    
    [self->audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
        
        double ddata[numFrames];
        for (int frame = 0; frame < numFrames; ++frame)
        {
            float floatVal = data[frame];
            ddata[frame] = (double)floatVal;
        }
        
        Yin yin = *new Yin(numFrames, weakSelf->audioManager.samplingRate);
        Yin::YinOutput pYin = yin.processProbabilisticYin(ddata);
        
        std::pair<double, double> highProbability;
        if (sizeof(pYin.freqProb) > 0)
        {
            for (std::vector<std::pair<double,double>>::iterator i = pYin.freqProb.begin(); i != pYin.freqProb.end(); ++i)
            {
                std::pair<double,double> pair = *i;
                if (pair.second > highProbability.second)
                {
                    highProbability = pair;
                }
            }
        }
        
        if (highProbability.second > 0.5)
        {
            weakSelf->probabilityFrequencies.push_back(highProbability);
            if (weakSelf.frequencyClosure != NULL)
            {
                weakSelf.frequencyClosure(highProbability.first);
            }
        }
    }];
    
    [self->audioManager play];
}

-(void)stop
{
    // stop collecting data
    [self->audioManager pause];
}

-(NSMutableArray*)getProbabilityFrequencies
{
    if (probabilityFrequencies.size() > 0)
    {
        int vectorCount = 0;
        freqArray = [[NSMutableArray alloc] init];
        for (std::vector<std::pair<double,double>>::iterator i = probabilityFrequencies.begin(); i != probabilityFrequencies.end(); ++i)
        {
            std::pair<double,double> pair = *i;
            NSNumber *freq = [NSNumber numberWithDouble:pair.first];
            [freqArray addObject:freq];
            vectorCount++;
        }
    }
    return freqArray;
}

@end

