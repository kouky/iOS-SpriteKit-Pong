//
//  PlayerNode.m
//  Pong
//
//  Created by Michael Koukoullis on 31/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "PlayerNode.h"
#import "PaddleNode.h"
#import "ScoreNode.h"

@implementation PlayerNode

- (id)init
{
    return [self initOnLeftSide];
}

- (id)initOnLeftSide
{
    self = [super init];
    if (self) {
        self.name = @"leftPlayer";
        PaddleNode *leftPaddle = [[PaddleNode alloc] initWithName:@"leftPaddle"];
        [self addChild:leftPaddle];
        ScoreNode *score = [[ScoreNode alloc] initWithName:@"leftScore"];
        [self addChild:score];
    }
    return self;
}

- (id)initOnRightSide
{
    self = [super init];
    if (self) {
        self.name = @"rightPlayer";
        PaddleNode *rightPaddle = [[PaddleNode alloc] initWithName:@"rightPaddle"];
        [self addChild:rightPaddle];
        ScoreNode *score = [[ScoreNode alloc] initWithName:@"rightScore"];
        [self addChild:score];
    }
    return self;
}

- (void)positionOnLeftSide
{
    SKNode *paddle = [self childNodeWithName:@"leftPaddle"];
    paddle.position = CGPointMake(100, CGRectGetMidY(self.parent.frame));
    
    SKNode *score = [self childNodeWithName:@"leftScore"];
    score.position = CGPointMake((CGRectGetMidX(self.parent.frame) - 50), self.parent.frame.size.height - 50);
}

- (void)positionOnRightSide
{
    SKNode *paddle = [self childNodeWithName:@"rightPaddle"];
    paddle.position = CGPointMake(self.parent.frame.size.width - 100, CGRectGetMidY(self.parent.frame));
    
    SKNode *score = [self childNodeWithName:@"rightScore"];
    score.position = CGPointMake((CGRectGetMidX(self.parent.frame) + 50), self.parent.frame.size.height - 50);

}


@end
