//
//  Paddle.m
//  Pong
//
//  Created by Michael Koukoullis on 17/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "PaddleNode.h"
#import "NodeCategories.h"

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

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    CGPoint movePoint = CGPointMake(self.position.x, touchPoint.y);
    if ([self withinParentFrame:movePoint])
        self.position = movePoint;
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
    return CGPointMake((point.x / (self.size.width / 2)), (point.y / (self.size.height / 2)));
}

@end
