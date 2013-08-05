//
//  ContactVisitor.h
//  Pong
//
//  Created by Michael Koukoullis on 29/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface ContactVisitor : NSObject

@property (nonatomic,readonly, strong) SKPhysicsBody *body;
@property (nonatomic, readonly, strong) SKPhysicsContact *contact;

+ (id)contactVisitorWithBody:(SKPhysicsBody *)body forContact:(SKPhysicsContact *)contact;
- (void)visit:(SKPhysicsBody *)body;

@end
