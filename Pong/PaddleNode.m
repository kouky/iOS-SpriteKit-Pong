//
//  Paddle.m
//  Pong
//
//  Created by Michael Koukoullis on 17/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "PaddleNode.h"
#import "NodeCategories.h"

static const float movingAveragelambda = 0.8;

@interface PaddleNode ()
@property (nonatomic, assign) NSTimeInterval previousTouchesTimestamp;
@property (nonatomic, assign, readwrite) float speed;
@end

@implementation PaddleNode

- (id)init
{
    return [self initWithName:@"paddle"];
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(10, 50);
        self.color = [SKColor whiteColor];
        self.userInteractionEnabled = YES;
        self.name = name;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsBody.categoryBitMask = paddleCategory;
        self.physicsBody.collisionBitMask = emptyCategory;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.previousTouchesTimestamp = event.timestamp;
    self.speed = 0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.speed = 0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // Move the paddle vertically if the new position is within
    // the parent frame. SKNode positions are centered.
    CGPoint touchPoint = [touch locationInNode:self.scene];
    CGPoint movePoint = CGPointMake(self.position.x, touchPoint.y);
    if ([self withinParentFrame:movePoint])
        self.position = movePoint;
    
    // Approximate the speed of the paddle using an exponential moving average
    CGPoint previousTouchPoint = [touch previousLocationInNode:self.scene];
    float distanceFromPrevious = fabs(touchPoint.y - previousTouchPoint.y);
    NSTimeInterval timeSincePrevious = event.timestamp - self.previousTouchesTimestamp;
    float newSpeed = (1.0 - movingAveragelambda) * self.speed + movingAveragelambda * (distanceFromPrevious/timeSincePrevious);

    self.speed = newSpeed;
    self.previousTouchesTimestamp = event.timestamp;
}

- (BOOL)withinParentFrame:(CGPoint)point
{
    CGFloat offset = self.size.height / 2;
    if (point.y >= offset && point.y <= self.scene.frame.size.height - offset)
        return YES;
    else
        return NO;
}

- (CGPoint)normalisePoint:(CGPoint)point
{
    CGFloat x = point.x / (self.size.width / 2);
    if (x > 1.0)
        x = 1.0;
    else if (x < -1.0)
        x = -1.0;
    
    CGFloat y = point.y / (self.size.height / 2);
    if (y > 1.0)
        y = 1.0;
    else if (y < -1.0)
        y = -1.0;
    
    return CGPointMake(x,y);
}

@end
