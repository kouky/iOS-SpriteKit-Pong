//
//  BallContactVisitor.h
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "ContactVisitor.h"

@interface BallNodeContactVisitor : ContactVisitor

- (void)visitPlayfieldScene:(SKPhysicsBody *)playfieldBody;

// Alternatively we can handle the paddle hitting the ball here
//- (void)visitPaddleNode:(SKPhysicsBody *)paddleBody;

@end
