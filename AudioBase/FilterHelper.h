//
//  FilterHelper.h
//  AudioBase
//
//  Created by Chris Saunders on 2/09/2015.
//  Copyright (c) 2015 tenKinetic. All rights reserved.
//

#ifndef AudioBase_FilterHelper_h
#define AudioBase_FilterHelper_h

#import <Foundation/Foundation.h>

@interface FilterHelper : NSObject

-(void)startHPF;
-(void)startPassthrough;
-(void)stop;

@end

#endif
