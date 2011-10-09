//
//  Squiggle.h
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



@interface Squiggle : NSObject
{
    NSMutableArray *pointsArray;
	UIColor *strokeColor;
	float lineWidth;
}

@property (nonatomic, retain) NSMutableArray *pointsArray;
@property (nonatomic, retain) UIColor *strokeColor;
@property float lineWidth;

- (void)addPoint:(CGPoint)point;

@end
