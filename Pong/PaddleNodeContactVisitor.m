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
    
    // Interpolate the ball reflection angle based on the vertical contact point with the paddle
    // Cap the reflection at 90 degress arc from the center of the paddles
    float interpolatedReflectionAngle = 0;
    if ([paddle.name isEqualToString:@"leftPaddle"]) {
        interpolatedReflectionAngle = M_PI_2 - (normalisedPoint.y * M_PI_4);
    } else if ([paddle.name isEqualToString:@"rightPaddle"]) {
        interpolatedReflectionAngle = M_PI + M_PI_2 + (normalisedPoint.y * M_PI_4);
    }
    
    // Determine the velocity magnitude for the ball based on the
    // speed of the paddle on contact.
    float paddleSpeedNormalised = fabs(paddle.speed / 2000);  // 2000 is an arbitrary normalisation factor
    if (paddleSpeedNormalised > 1.0)
        paddleSpeedNormalised = 1.0;
    else if (paddleSpeedNormalised < 0)
        paddleSpeedNormalised = 0;

    float velocityMagnitude = 300 + 500 * paddleSpeedNormalised;
    
    // Set the ball velocity
    [ball setVelocityWithRadians:interpolatedReflectionAngle Magnitude:velocityMagnitude];
}

@end
