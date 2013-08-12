//
//  Paddle.h
//  Pong
//
//  Created by Michael Koukoullis on 17/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PaddleNode : SKSpriteNode

@property (nonatomic, readonly) float speed;

- (id)initWithName:(NSString *)name;
- (CGPoint)normalisePoint:(CGPoint)point;

@end
