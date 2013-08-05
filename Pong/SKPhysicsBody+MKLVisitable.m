//
//  SKPhysicsBody+MKLVisitable.m
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import "SKPhysicsBody+MKLVisitable.h"

//@implementation SKPhysicsBody (MKLVisitable)
@implementation NSObject (MKLVisitable)

- (void)mkl_acceptVisitor:(ContactVisitor *)contact
{
    SKPhysicsBody *body = (SKPhysicsBody *) self;
    [contact visit:body];
}

@end
