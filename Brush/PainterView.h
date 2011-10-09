//
//  PainterView.h
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Squiggle.h"

@interface PainterView : UIView {
	//正在绘的曲线
	NSMutableDictionary *squigglesDic;
	//已经完成的曲线
	NSMutableArray *finishSquiggles;
    
	UIColor *color;
	float lineWidth;
}

@property (nonatomic, retain) UIColor *color;
@property float lineWidth;

- (void)drawSquiggle:(Squiggle *)squiggle inContext:(CGContextRef)context;

- (void)resetView;

@end
