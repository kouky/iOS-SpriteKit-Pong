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
#import "SKPhysicsBody+MKLVisitable.h"

static const CGFloat contactTolerance = 1.0;

@interface PlayfieldScene ()
@property BOOL contentCreated;
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

    BallNode *ball = [[BallNode alloc] initWithRadius:10];
    [self addChild:ball];
    
    PlayerNode *leftPlayer = [[PlayerNode alloc] initOnLeftSide];
    [self addChild:leftPlayer];
    
    PlayerNode *rightPlayer = [[PlayerNode alloc] initOnRightSide];
    [self addChild:rightPlayer];

}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    firstBody = (SKPhysicsBody *) contact.bodyA;
    secondBody = (SKPhysicsBody *) contact.bodyB;
    
    // The nasty way to handle contacts, this will get out of hand
    // quickly as we add more physics nodes to the scene.
    
//    if ((firstBody.categoryBitMask & ballCategory) != 0 && (secondBody.categoryBitMask & edgeCategory) != 0) {
//        BallNode *ball = (BallNode *)[firstBody node];
//        [ball reflectVelocityForContactWithPoint:contact.contactPoint inBounds:self.frame];
//    } else if ((secondBody.categoryBitMask & ballCategory) != 0 && (firstBody.categoryBitMask & edgeCategory) != 0) {
//        BallNode *ball = (BallNode *)[secondBody node];
//        [ball reflectVelocityForContactWithPoint:contact.contactPoint inBounds:self.frame];
//    } else if ((firstBody.categoryBitMask & ballCategory) != 0 && (secondBody.categoryBitMask & paddleCategory) != 0) {
//        BallNode *ball = (BallNode *)[firstBody node];
//        [ball reflectHorizontalVelocity];
//    } else if ((secondBody.categoryBitMask & ballCategory) != 0 && (firstBody.categoryBitMask & paddleCategory) != 0) {
//        BallNode *ball = (BallNode *)[secondBody node];
//        [ball reflectHorizontalVelocity];
//    }
    
    // Alternatively use the visitor pattern for a double dispatch approach    
    [firstBody mkl_acceptVisitor:[ContactVisitor contactVisitorWithBody:secondBody forContact:contact]];
    [secondBody mkl_acceptVisitor:[ContactVisitor contactVisitorWithBody:firstBody forContact:contact]];
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
    if (floorf(point.x) <= contactTolerance) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPointOnRightEdge:(CGPoint)point
{
    if (ceilf(point.x) >= self.frame.size.width - contactTolerance) {
        return YES;
    } else {
        return NO;
    }
}


@end
