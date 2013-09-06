//
//  BallNode.h
//  Pong
//
//  Created by Michael Koukoullis on 15/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BallNode : SKShapeNode

- (id)initWithRadius:(float)radius;
- (void)reflectVerticalVelocity;
- (void)resetPosition;
- (void)serveLeftwards;
- (void)serveRightwards;
- (void)setVelocityWithRadians:(float)radians Magnitude:(float)magnitude;

@end
