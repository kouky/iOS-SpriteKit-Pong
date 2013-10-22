//
//  VisitablePhysicsBody.h
//  Pong
//
//  Created by Mike on 16/10/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ContactVisitor.h"

@interface VisitablePhysicsBody : NSObject

@property (nonatomic, readonly, strong) SKPhysicsBody *body;

- (id) initWithBody:(SKPhysicsBody *)body;
- (void) acceptVisitor:(ContactVisitor *)contact;

@end
