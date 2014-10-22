//
//  PlayerView.m
//  airplay-evaluate
//
//  Created by Anders Frank on 2014-10-21.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "PlayerView.h"


@interface PlayerView ()

@end

@implementation PlayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inBackground = NO;
    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    _player = player;
    [self updateLayerPlayer];
}

- (void)setInBackground:(BOOL)inBackground {
    _inBackground = inBackground;
    [self updateLayerPlayer];
    
}

- (void)updateLayerPlayer {
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    if (self.inBackground) {
        [playerLayer setPlayer:nil];
    } else {
        [playerLayer setPlayer:self.player];
    }
    NSLog(@"playerLayer.player: %@",playerLayer.player);
}


@end
