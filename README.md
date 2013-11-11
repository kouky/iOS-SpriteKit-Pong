# Double Dispatch Sprite Kit Pong

An implementation of the classic video game Pong using Sprite Kit, an Apple graphics rendering and animation framework.

This implementation provides a working example of the recommendation in the Sprite Kit programming guide to use the Double Dispatch Pattern to farm out work associated with node physics body contacts in the simulation.

## Scene and Node Setup

Our game consists of a PlayfieldScene with a PhysicsBody edge loop, a BallNode, and two PlayerNodes each comprised of a PaddleNode and ScoreNode. The BallNode and PaddleNodes are configured with physics bodies to allow for contact detection.

To replicate the classic gameplay velocities of the BallNode are manually altered on contact with other bodies, rather than relying on the physics collision capabilities of Sprite Kit. The ball's vertical velocity is simply reflected when it hits the top or bottom edge of the PlayFieldScene. 

When the ball contacts the  PaddleNode the horizontal velocity is reflected within an interpolated 90 degree arc based on the contact point. The magnitude of the reflected BallNode velocity is proportional to the speed of the PaddleNode on contact.

## Handling Physics Body Contacts Naively

The PlayfieldScene is assigned as the contact delegate for the physics world and implements the contact delegate method *didBeginContact*.

The main observation to make is that the bodies in a contact can appear in any order. For example the first two clauses in the conditional below are essectially checking for the same thing, that the ball is contacting the playfield scene edges.

```objective-c
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if ((firstBody.categoryBitMask & ballCategory) != 0 &&
        (secondBody.categoryBitMask & playfieldCategory) != 0) {
        
        BallNode *ball = (BallNode *)[firstBody node];
        // Perform something
        
    } else if ((secondBody.categoryBitMask & ballCategory) != 0 &&
               (firstBody.categoryBitMask & playfieldCategory) != 0) {
        
        BallNode *ball = (BallNode *)[secondBody node];
        // Perform the same something
        
    } else if ((firstBody.categoryBitMask & ballCategory) != 0 &&
               (secondBody.categoryBitMask & paddleCategory) != 0) {
        
        BallNode *ball = (BallNode *)[firstBody node];
        // Perform something else
        
    } else if ((secondBody.categoryBitMask & ballCategory) != 0 &&
               (firstBody.categoryBitMask & paddleCategory) != 0) {
        
        BallNode *ball = (BallNode *)[secondBody node];
        // Perform the same something else
    }
}
```

The problem with the approach above is two fold. 

Firstly embedding all the logic in the scene's contact delegate method will result in a long unreadable delegate method  as the number of nodes in the simulation increases. Farming this work out to contact handlers would be much better.

Secondly the code required to handle the outcome of each contact, needs to be written in or referenced twice. This could be addressed by by combining the double up with an OR operation, not that great for legibility. 

```objective-c
    if (((firstBody.categoryBitMask & ballCategory) != 0 &&
         (secondBody.categoryBitMask & playfieldCategory) != 0) ||
        
        ((secondBody.categoryBitMask & ballCategory) != 0 &&
         (firstBody.categoryBitMask & playfieldCategory) != 0)) {
        
        BallNode *ball = (BallNode *)[firstBody node];
        // Perform something
        
    }
```

Another approach to counter the double up is the bitwise sorting approach in the programming guide's rocket contact example code example, reproduced below.

```objective-c
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & missileCategory) != 0)
    {
        [self attack: secondBody.node withMissile:firstBody.node];
    }
```

This introduces the need for every node in the simulation to respond to a verb based method like 'attack', which may end up being a no-op for most nodes. Also you're still going to require further nested conditionals to determine the outcome based on both bodies in the contact.

## Handling Physics Body Contacts with Double Dispatch

## References

[Sprite Kit Programming Guide](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html) and in particular the [Simulating Physics](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Physics/Physics.html#//apple_ref/doc/uid/TP40013043-CH6-SW1) chapter.

[Visitor Pattern and Double Dispatch in Ruby](http://blog.bigbinary.com/2013/07/07/visitor-pattern-and-double-dispatch.html) by Neeraj Singh.
