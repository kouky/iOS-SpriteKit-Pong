//
//  PlayerNode.h
//  Pong
//
//  Created by Michael Koukoullis on 31/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerNode : SKNode

- (id)initOnLeftSide;
- (id)initOnRightSide;
- (void)positionOnLeftSide;
- (void)positionOnRightSide;

@end
