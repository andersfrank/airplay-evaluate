//
//  AVPlayer+RAC.m
//  Dplay
//
//  Created by Anders Frank on 2014-10-17.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "AVPlayer+RAC.h"

@implementation AVPlayer (RAC)

- (RACSignal *)periodicTimeObserveWithRefreshInterval:(CGFloat)refreshInterval {
    CMTime interval = CMTimeMakeWithSeconds(refreshInterval, NSEC_PER_SEC);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        id token = [self addPeriodicTimeObserverForInterval:interval
                                                      queue:NULL
                                                 usingBlock:^(CMTime time){
                                                     
                                                     NSTimeInterval currentTime = CMTimeGetSeconds(time);
                                                     [subscriber sendNext:@(currentTime)];
                                                 }];
        NSLog(@"adding periodic time observer: %@",token);
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"removing time observer: %@",token);
            [self removeTimeObserver:token];
        }];

    }];
    
}

- (RACSignal *)currentTimeEqualsOrExceeded:(CGFloat)time {
    return [[[self periodicTimeObserveWithRefreshInterval:0.5] filter:^BOOL(NSNumber *currentTime) {
        return currentTime.floatValue >= time;
    }] take:1];
}


@end
