//
//  PlayfieldScene.m
//  Pong
//
//  Created by Michael Koukoullis on 8/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "PlayfieldScene.h"
#import "BallNode.h"
#import "PlayerNode.h"
#import "NodeCategories.h"
#import "VisitablePhysicsBody.h"

static const CGFloat  contactTolerance          = 1.0;
static const uint32_t emptyBallStatus           = 0x0;
static const uint32_t serveBallLeftwardsStatus  = 0x1 << 0;
static const uint32_t serveBallRightwardsStatus = 0x1 << 1;

@interface PlayfieldScene ()
@property BOOL contentCreated;
@property uint32_t ballStatus;
@end

@implementation PlayfieldScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeResizeFill;

    BallNode *ball = [[BallNode alloc] init];
    [self addChild:ball];
    
    PlayerNode *leftPlayer = [[PlayerNode alloc] initOnLeftSide];
    [self addChild:leftPlayer];
    
    PlayerNode *rightPlayer = [[PlayerNode alloc] initOnRightSide];
    [self addChild:rightPlayer];

}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    // Inspect these closely, they're actually private class instances of PKPhysicsBody
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    // The naive way to handle contacts, this will get out of hand
    // quickly as we add more physics bodies to the simulation
    
//    if (((firstBody.categoryBitMask & ballCategory) != 0 &&
//         (secondBody.categoryBitMask & playfieldCategory) != 0) ||
//        
//        ((secondBody.categoryBitMask & ballCategory) != 0 &&
//         (firstBody.categoryBitMask & playfieldCategory) != 0)) {
//        
//        BallNode *ball = (BallNode *)[firstBody node];
//        // Perform something
//        
//    } else if ((secondBody.categoryBitMask & ballCategory) != 0 &&
//               (firstBody.categoryBitMask & playfieldCategory) != 0) {
//        
//        BallNode *ball = (BallNode *)[secondBody node];
//        // Perform the same something
//        
//    } else if ((firstBody.categoryBitMask & ballCategory) != 0 &&
//               (secondBody.categoryBitMask & paddleCategory) != 0) {
//        
//        BallNode *ball = (BallNode *)[firstBody node];
//        // Perform something else
//        
//    } else if ((secondBody.categoryBitMask & ballCategory) != 0 &&
//               (firstBody.categoryBitMask & paddleCategory) != 0) {
//        
//        BallNode *ball = (BallNode *)[secondBody node];
//        // Perform the same something else
//    }
    
    // Alternatively use the visitor pattern for a double dispatch approach        
    VisitablePhysicsBody *firstVisitableBody = [[VisitablePhysicsBody alloc] initWithBody:firstBody];
    VisitablePhysicsBody *secondVisitableBody = [[VisitablePhysicsBody alloc] initWithBody:secondBody];
    
    [firstVisitableBody acceptVisitor:[ContactVisitor contactVisitorWithBody:secondBody forContact:contact]];
    [secondVisitableBody acceptVisitor:[ContactVisitor contactVisitorWithBody:firstBody forContact:contact]];
    
}

// Using didChangeSize as a proxy to initialise the scene edges and nodes within
// the correct scene bounds, currently can't be done in didMoveToView.
// This is bad but fingers crossed on Apple fixing this problem.
- (void)didChangeSize:(CGSize)oldSize
{
    NSLog(@"Size change to w:%f h:%f", self.size.width, self.size.height);
    if (self.contentCreated) {
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = playfieldCategory;
        self.physicsBody.contactTestBitMask = emptyCategory;
        self.physicsWorld.contactDelegate = self;
        
        BallNode *ball = (BallNode *) [self childNodeWithName:@"ball"];
        [ball resetPosition];
        
        PlayerNode *leftPlayer = (PlayerNode *) [self childNodeWithName:@"leftPlayer"];
        [leftPlayer positionOnLeftSide];
        
        PlayerNode *rightPlayer = (PlayerNode *) [self childNodeWithName:@"rightPlayer"];
        [rightPlayer positionOnRightSide];
    }
}

- (BOOL)isPointOnLeftEdge:(CGPoint)point
{
    if (floorf(point.x) <= contactTolerance)
        return YES;
    else
        return NO;
}

- (BOOL)isPointOnRightEdge:(CGPoint)point
{
    if (ceilf(point.x) >= self.frame.size.width - contactTolerance)
        return YES;
    else
        return NO;
}

- (void)serveBallLeftwards
{
    BallNode *ball = (BallNode *) [self childNodeWithName:@"ball"];
    if (ball) {
        [ball removeFromParent];
        self.ballStatus = serveBallLeftwardsStatus;;
    }
}

- (void)serveBallRightwards
{
    BallNode *ball = (BallNode *) [self childNodeWithName:@"ball"];
    if (ball) {
        [ball removeFromParent];
        self.ballStatus = serveBallRightwardsStatus;;
    }
    
}

- (void)update:(NSTimeInterval)currentTime
{
    // Seems that we can't just update the position of the ball
    // during contact detection, needs to be done duting the update
    // stage of scene processing
    if ((self.ballStatus & serveBallLeftwardsStatus) != 0) {
        self.ballStatus = emptyBallStatus;
        BallNode *ball = [[BallNode alloc] init];
        [self addChild:ball];
        [ball resetPosition];
        [ball serveLeftwards];
    }

    if ((self.ballStatus & serveBallRightwardsStatus) != 0) {
        self.ballStatus = emptyBallStatus;
        BallNode *ball = [[BallNode alloc] init];
        [self addChild:ball];
        [ball resetPosition];
        [ball serveLeftwards];
    }
}

@end
