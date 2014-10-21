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

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    _player = player;
    [(AVPlayerLayer *) [self layer] setPlayer:player];
}

@end
