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
    
    // Interpolate the ball reflection angle based on the vertical contact point with paddle
    // Cap the reflection at 45 degrees
    float interpolatedReflectionAngle = M_PI_4 * normalisedPoint.y;
    if (interpolatedReflectionAngle > 0.5)
        interpolatedReflectionAngle = 0.5;
    else if (interpolatedReflectionAngle < -0.5)
        interpolatedReflectionAngle = -0.5;
    
    // Determine the velocity magnitude for the ball based on the
    // speed of the paddle on contact.
    float paddleSpeedNormalised = fabs(paddle.speed / 2000);  // 2000 is an arbitrary normalisation factor
    if (paddleSpeedNormalised > 1.0)
        paddleSpeedNormalised = 1.0;
    else if (paddleSpeedNormalised < 0)
        paddleSpeedNormalised = 0;

    float velocityMagnitude = 300 + 500 * paddleSpeedNormalised;
    
    // Determine the ball velocity component vectors
    float horizontalVelocity = velocityMagnitude * cos(interpolatedReflectionAngle);
    float verticalVelocity = velocityMagnitude * sin(interpolatedReflectionAngle);
    
    // Make sure the horizintal velocity for the ball is reflected
    if ([paddle.name isEqualToString:@"leftPaddle"])
        horizontalVelocity = fabsf(horizontalVelocity);
    else if ([paddle.name isEqualToString:@"rightPaddle"])
        horizontalVelocity = -1 * fabsf(horizontalVelocity);
    
    // Set the ball velocity
    ballBody.velocity = CGVectorMake(horizontalVelocity, verticalVelocity);
}

@end
