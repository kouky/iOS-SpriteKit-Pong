//
//  VisitablePhysicsBody.m
//  Pong
//
//  Created by Mike on 16/10/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "VisitablePhysicsBody.h"

@implementation VisitablePhysicsBody

- (id)initWithBody:(SKPhysicsBody *)body
{
    self = [super init];
    if (self) {
        _body = body;
    }
    return self;
}

- (void)acceptVisitor:(ContactVisitor *)contact
{
    [contact visit:self.body];
}

@end
