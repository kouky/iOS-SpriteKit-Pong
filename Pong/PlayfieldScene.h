//
//  PlayfieldScene.h
//  Pong
//
//  Created by Michael Koukoullis on 8/07/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayfieldScene : SKScene <SKPhysicsContactDelegate>

- (BOOL)isPointOnLeftEdge:(CGPoint)point;
- (BOOL)isPointOnRightEdge:(CGPoint)point;
- (void)serveBallLeftwards;
- (void)serveBallRightwards;

@end
