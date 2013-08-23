//
//  BallNode.m
//  Pong
//
//  Created by Michael Koukoullis on 15/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "BallNode.h"
#import "NodeCategories.h"

static const CGFloat contactTolerance = 1.0;

@implementation BallNode

- (id)init
{
    return [self initWithRadius:10];
}

- (id)initWithRadius:(float)radius
{
    self = [super init];
    if (self) {
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddArc(pathRef, NULL, 0,0, radius, 0, M_PI*2, YES);
        self.path = pathRef;
        self.fillColor = [SKColor whiteColor];
        self.strokeColor = [SKColor redColor];
        self.userInteractionEnabled = YES;
        self.hidden = YES;
        self.name = @"ball";
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(radius)];
        self.physicsBody.categoryBitMask = ballCategory;
        self.physicsBody.contactTestBitMask = playfieldCategory | paddleCategory;
        self.physicsBody.collisionBitMask = emptyCategory;
        self.physicsBody.linearDamping = 0;
        self.physicsBody.angularDamping = 0;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.usesPreciseCollisionDetection = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.physicsBody.velocity = CGVectorMake(400, -100);
}

- (void)resetPosition
{
    self.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    self.hidden = NO;
}

- (void)resetForScore
{
    [self resetPosition];
    self.physicsBody.velocity = CGVectorMake(400, -100);
}

- (void)reflectVerticalVelocity
{
    CGFloat x = self.physicsBody.velocity.dx;
    CGFloat y = -1 * self.physicsBody.velocity.dy;
    self.physicsBody.velocity = CGVectorMake(x,y);
}

- (void)setVelocityWithRadians:(float)radians Magnitude:(float)magnitude
{
    float horizontalVelocity = magnitude * sin(radians);
    float verticalVelocity = magnitude * cos(radians);
    self.physicsBody.velocity = CGVectorMake(horizontalVelocity, verticalVelocity);
}

@end
