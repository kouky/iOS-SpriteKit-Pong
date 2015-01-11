//
//  ResetNode.m
//  Pong
//
//  Created by Michael Koukoullis on 11/01/2015.
//  Copyright (c) 2015 Michael Koukoullis. All rights reserved.
//

#import "ResetNode.h"
#import "PlayfieldScene.h"

@implementation ResetNode

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.userInteractionEnabled = YES;
        self.name = @"reset";
        self.size = CGSizeMake(60, 20);
        self.color = [SKColor darkGrayColor];
        
        SKLabelNode *labelNode = [[SKLabelNode alloc] init];
        labelNode.text = @"RESET";
        labelNode.fontColor = [SKColor whiteColor];
        labelNode.fontSize = 14.0;
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:labelNode];
    }
    
    return self;
}

- (void)resetPosition
{
    self.position = CGPointMake(CGRectGetMidX(self.scene.frame), self.parent.frame.size.height - 38);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    PlayfieldScene *playFieldScene = (PlayfieldScene *)self.scene;
    [playFieldScene reset];
}

@end
