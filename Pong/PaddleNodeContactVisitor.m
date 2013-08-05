//
//  PaddleContactVisitor.m
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "PaddleNodeContactVisitor.h"
#import "BallNode.h"
#import "PaddleNode.h"

@implementation PaddleNodeContactVisitor

// Deals with contact between the paddle and the ball
- (void)visitBallNode:(SKPhysicsBody *)ballBody
{
    BallNode *ball = (BallNode *) ballBody.node;
    PaddleNode *paddle = (PaddleNode *) self.body.node;
    
    // Normalise the contact point in the co-ordinate system of the paddle
    CGPoint point = [paddle convertPoint:self.contact.contactPoint fromNode:ball.scene];
    CGPoint normalisedPoint = [paddle normalisePoint:point];
    
    // Interpolate the ball reflection angle based on the vertical contact point witht paddle
    // Cap the reflection at 45 degrees
    float interpolatedReflectionAngle = M_PI_4 * normalisedPoint.y;
    if (interpolatedReflectionAngle > 0.5) {
        interpolatedReflectionAngle = 0.5;
    } else if (interpolatedReflectionAngle < -0.5) {
        interpolatedReflectionAngle = -0.5;
    }
    
    // Determine the velocity component vectors based on a constant
    // velocity magnitude of 400 units
    float horizontalVelocity = 400 * cos(interpolatedReflectionAngle);
    float verticalVelocity = 400 * sin(interpolatedReflectionAngle);
    
    // Make sure the horizintal velocity is reflected
    if ([paddle.name isEqualToString:@"leftPaddle"]) {
        horizontalVelocity = fabsf(horizontalVelocity);
    } else if ([paddle.name isEqualToString:@"rightPaddle"]) {
        horizontalVelocity = -1 * fabsf(horizontalVelocity);
    }
    
    // Set the ball velocity
    ballBody.velocity = CGPointMake(horizontalVelocity, verticalVelocity);
}

@end
