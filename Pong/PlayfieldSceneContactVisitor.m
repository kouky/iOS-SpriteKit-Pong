//
//  EdgeContactVisitor.m
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "PlayFieldSceneContactVisitor.h"
#import "BallNode.h"

@implementation PlayfieldSceneContactVisitor

// Alternatively we can handle the ball hitting the scene edges here
//
//- (void)visitBallNode:(SKPhysicsBody *)ballBody
//{
//    BallNode *ball = (BallNode *) ballBody.node;
//    [ball reflectVelocityForContactWithPoint:self.contact.contactPoint inBounds:self.body.node.frame];
//}

@end
