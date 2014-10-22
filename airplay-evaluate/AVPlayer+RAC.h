//
//  AVPlayer+RAC.h
//  Dplay
//
//  Created by Anders Frank on 2014-10-17.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AVPlayer (RAC)
- (RACSignal *)periodicTimeObserveWithRefreshInterval:(CGFloat)refreshInterval;
- (RACSignal *)currentTimeEqualsOrExceeded:(CGFloat)time;
@end
