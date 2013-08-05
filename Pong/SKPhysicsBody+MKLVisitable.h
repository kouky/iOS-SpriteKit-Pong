//
//  SKPhysicsBody+MKLVisitable.h
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ContactVisitor.h"

// This should be a category on SKPhysicsBody, however
// the class of contact bofy objects attached to an
// SKPhysicsContact aer of a private class PKPhysicsBody,
// which we can't set a categoy on. So just for now
// I'm extending NSObject, which is bad, I know.

//@interface SKPhysicsBody (MKLVisitable)

@interface NSObject (MKLVisitable)
- (void) mkl_acceptVisitor:(ContactVisitor *)contact;
@end