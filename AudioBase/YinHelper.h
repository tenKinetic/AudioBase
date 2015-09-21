//
//  bridge.h
//  Claritone
//
//  Created by Chris Saunders on 31/08/2015.
//  Copyright (c) 2015 tenKinetic. All rights reserved.
//

#ifndef AudioBase_YinHelper_h
#define AudioBase_YinHelper_h

#import <Foundation/Foundation.h>

typedef void (^FrequencyClosure)(double frequency);

@interface YinHelper : NSObject

@property (nonatomic, copy) FrequencyClosure frequencyClosure;

-(void)analyse;
-(void)stop;
-(NSMutableArray*)getProbabilityFrequencies;

@end

#endif
