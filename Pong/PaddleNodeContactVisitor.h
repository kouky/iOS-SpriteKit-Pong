//
//  PaddleContactVisitor.h
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "ContactVisitor.h"

@interface PaddleNodeContactVisitor : ContactVisitor

- (void)visitBallNode:(SKPhysicsBody *)ballBody;

@end
