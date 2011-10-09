//
//  Squiggle.m
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Squiggle.h"

@implementation Squiggle

@synthesize pointsArray;
@synthesize strokeColor;
@synthesize lineWidth;

- (id)init
{
    self = [super init];
	if (self)
	{
		pointsArray = [[NSMutableArray alloc] init];
        strokeColor = [[UIColor alloc] init];
	}
	
	return self;
}

- (void)addPoint:(CGPoint)point 
{
	//这里得用NSValue将结构体类型的CGPoint转换为对象
	NSValue *value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
	[pointsArray addObject:value];
	
}

- (void)dealloc
{
	[strokeColor release];
	[pointsArray release];
    
	[super dealloc];
}

@end
