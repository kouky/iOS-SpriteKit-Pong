//
//  RandomHelper.h
//  Pong
//
//  Created by Michael Koukoullis on 6/09/13.
//  Copyright (c) 2013 Michael Koukoullis. All rights reserved.
//

#ifndef Pong_RandomHelper_h
#define Pong_RandomHelper_h

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

#endif
