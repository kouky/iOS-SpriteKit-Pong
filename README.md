# Double Dispatch Sprite Kit Pong

An implementation of the classic video game Pong using Sprite Kit, an Apple graphics rendering and animation framework.

This implementation provides a working example of the recommendation in the Sprite Kit programming guide to use Double Dispatch to farm out work associated with node physics body contacts in the simulation.

![Pong Screenshot](http://ec085a0a5b98f1ec5d97-65c493171c6d6a91bc23f798ea24c60a.r50.cf4.rackcdn.com/pong.jpg)


## Scene and Node Setup

Our game consists of a PlayfieldScene with a PhysicsBody edge loop, a BallNode, and two PlayerNodes each comprised of a PaddleNode and ScoreNode. The BallNode and PaddleNodes are configured with physics bodies to allow for contact detection.

To replicate the classic gameplay velocities of the BallNode are manually altered on contact with other bodies, rather than relying on the physics collision capabilities of Sprite Kit. The ball's vertical velocity is simply reflected when it hits the top or bottom edge of the PlayFieldScene. 

When the ball contacts the  PaddleNode the horizontal velocity is reflected within an interpolated 90 degree arc based on the contact point. The magnitude of the reflected BallNode velocity is proportional to the speed of the PaddleNode on contact.

## Handling Physics Body Contacts Naively

The PlayfieldScene is assigned as the contact delegate for the physics world and implements the contact delegate method *didBeginContact*.

The main observation to make is that the bodies in a contact can appear in any order. For example the first two clauses in the conditional below are essectially checking for the same thing, that the ball is contacting the PlayfieldScene edges.

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

Firstly embedding all the logic in the scene's contact delegate method will result in a long unreadable method as the number of nodes in the simulation increases. Farming this work out to contact handlers would be much better.

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

This approach will still require further nested conditionals to determine the outcome based on both bodies in the contact, which for all but the most trivial of simulations will most likely be the case. 

## Physics Body Contacts with Double Dispatch

Using the Visitor pattern we can double dispatch the outcome of the contact based on both bodies. The contact delegate no longer discerns the categroies of the physics body, its implementation shrinks to just the following.

```objective-c
- (void)didBeginContact:(SKPhysicsContact *)contact
{

    SKPhysicsBody *firstBody, *secondBody;
    // Inspect these closely, they're actually private class instances of PKPhysicsBody
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;

    VisitablePhysicsBody *firstVisitableBody = [[VisitablePhysicsBody alloc] initWithBody:firstBody];
    VisitablePhysicsBody *secondVisitableBody = [[VisitablePhysicsBody alloc] initWithBody:secondBody];
    
    [firstVisitableBody acceptVisitor:[ContactVisitor contactVisitorWithBody:secondBody forContact:contact]];
    [secondVisitableBody acceptVisitor:[ContactVisitor contactVisitorWithBody:firstBody forContact:contact]];
    
}
```

The _VisitablePhysicsBody_ class is a simple wrapper for an _SKPhysicsBody_ instance. It implements a method called accept, which accepts the visitor, and which in turn invokes the actual visit. A wrapper is used as _acceptVisitor_ cannot be implemented as a category on _SKPhysicsBody_ given the physics bodies carried by the _SKPhysicsContact_ instance are actually instances of private class _PKPhysicsBody_.

```objective-c
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
```

Out _ContactVisitor_ base class implements convenience constructor _contactVisitorWithBody:forContact_ which constructs one of its subclasses based on the physics body category of it's first argument. This is the first part of the double dispatch, we have an instance of a class which is named after one of the bodies in the contact e.g. _BallNodeContactVisitor_ _PaddleNodeContactVisitor_ etc.


```objective-c
@implementation ContactVisitor

+ (id)contactVisitorWithBody:(SKPhysicsBody *)body forContact:(SKPhysicsContact *)contact
{
    if ((body.categoryBitMask & ballCategory) !=0) {
        return [[BallNodeContactVisitor alloc] initWithBody:body forContact:contact];
    } else if ((body.categoryBitMask & playfieldCategory) != 0) {
        return [[PlayfieldSceneContactVisitor alloc] initWithBody:body forContact:contact];
    } else if ((body.categoryBitMask & paddleCategory) != 0) {
        return [[PaddleNodeContactVisitor alloc] initWithBody:body forContact:contact];
    } else {
        return nil;
    }
}

- (id)initWithBody:(SKPhysicsBody *)body forContact:(SKPhysicsContact *)contact
{
    self = [super init];
    if (self) {
        _contact = contact;
        _body = body;
    }
    return self;
}

...

```

The _visit_ method in our _ContactVisitor_ implements the second part of the double dispatch by sending a message named after the second physics body in the contact to the newly constructed _ContactVisitor_ subclass instance which is named after the first body in the contact e.g. _visitBallNode_ _visitPaddleNode_ etc.


```objective-c
...

- (void)visit:(SKPhysicsBody *)body
{
    // This will generate strings like "BallNode", "PaddleNode", or "PlayfieldScene"
    NSString *bodyClassName = [NSString stringWithUTF8String:class_getName(body.node.class)];
    
    // This will generate strings like "visitBallNode:", "visitPaddleNode:", or "visitPlayfieldScene"
    NSMutableString *contactSelectorString = [NSMutableString stringWithFormat:@"visit"];
    [contactSelectorString appendString:bodyClassName];
    [contactSelectorString appendString:@":"];

    SEL selector = NSSelectorFromString(contactSelectorString);
    
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:body];
    }
    
}

@end
```

We now have a class _BallNodeContactVisitor_ which is solely concenred with handling contacts for nodes of class _BallNode_. The methods within the class follow a naming convention determined by the _visit_ method and allows us to determine the outcome of the contact with other node types.

```objective-c
@implementation BallNodeContactVisitor

// Handles contacts with PlayfieldScene edges
- (void)visitPlayfieldScene:(SKPhysicsBody *)playfieldBody
{
    
    BallNode *ball = (BallNode *) self.body.node;
    PlayfieldScene *playfield = (PlayfieldScene *) playfieldBody.node;
    // Perform something
}

// Handles contacts with PaddleNodes
- (void)visitPaddleNode:(SKPhysicsBody *)paddleBody
{
    BallNode *ball = (BallNode *) self.body.node;
    PaddleNode *paddle= (PaddleNode *) paddleBody.node;
    // Perform something else
}

@end
```

On the flip side we have another class named _PaddleNodeContactVisitor_ which handles contacts for nodes of class _PaddleNode_. 

```objective-c
@implementation PaddleNodeContactVisitor

// Handles contacts with BallNodes
- (void)visitBallNode:(SKPhysicsBody *)ballBody
{
    BallNode *ball = (BallNode *) ballBody.node;
    PaddleNode *paddle = (PaddleNode *) self.body.node;
    // Perform something
}

@end
```

You can handle the same contact in two seperate places, but you only really want to do it in one place. In the examples above the same contact between the _BallNode_ and the _PaddleNode_ will be dispatched to both the instances of _BallNodeContactVisitor_ and _PaddleNodeVisitor_ if they implement the respective methods _visitPaddleNode_ and _visitBallNode_. These methods don't have to be implemneted as the _ContactVisitor_ base class _visit_ method checks if they respond to the selectors firstly. In practice you'd only implement either _visitPaddleNode_ or _visitBallNode_.

## References

[Sprite Kit Programming Guide](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html) and in particular the [Simulating Physics](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Physics/Physics.html#//apple_ref/doc/uid/TP40013043-CH6-SW1) chapter.

[Visitor Pattern and Double Dispatch in Ruby](http://blog.bigbinary.com/2013/07/07/visitor-pattern-and-double-dispatch.html) by Neeraj Singh.
