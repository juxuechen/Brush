//
//  PainterView.m
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PainterView.h"

@implementation PainterView

@synthesize color;
@synthesize lineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor whiteColor];
        
		squigglesDic = [[NSMutableDictionary alloc] init];
		finishSquiggles = [[NSMutableArray alloc] init];
		color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
		lineWidth = 5;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	for (Squiggle *squiggle in finishSquiggles)
	{
		[self drawSquiggle:squiggle inContext:context];
	}
	
	for (NSString *key in squigglesDic)
	{
		Squiggle *squiggle = [squigglesDic valueForKey:key];
		[self drawSquiggle:squiggle inContext:context];
	}
}

- (void)drawSquiggle:(Squiggle *)squiggle inContext:(CGContextRef)context
{
	UIColor *squiggleColor = squiggle.strokeColor;
	CGColorRef colorRef = [squiggleColor CGColor];
	CGContextSetStrokeColorWithColor(context, colorRef);
	
	CGContextSetLineWidth(context, squiggle.lineWidth);
	NSMutableArray *pointArray1 = [squiggle pointsArray];
	
	CGPoint firstPoint;
	//复制第1个元素值到firstPoint点中
	[[pointArray1 objectAtIndex:0] getValue:&firstPoint];
	CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
	for (int i = 1; i < [pointArray1 count]; i++)
	{
		NSValue *value = [pointArray1 objectAtIndex:i];
		CGPoint point ;
		//将下一个点复制值,然后再在这两点之间画线
		[value getValue:&point];
		CGContextAddLineToPoint(context, point.x, point.y);
	}
	
	CGContextStrokePath(context);
}

//触摸点开始记录,一移动再记录,这样就记录无数多个点便成了线
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *array = [touches allObjects];
	//	NSLog(@"%d  Began   array %@",[array count],array);
	for (UITouch *touch in array)
	{
		Squiggle *squiggle = [[Squiggle alloc] init];
		[squiggle setLineWidth:lineWidth];  // 设置线宽
		[squiggle setStrokeColor:color];    // 设置画笔颜色
		
        //self  指当前这次触摸事件
		[squiggle addPoint:[touch locationInView:self]];
		
		//因为每次触摸事件的 内存地址唯一,所以将其作为 squiggle的关键字key
		//将内存地址转换为对象
		NSValue *touchValue = [NSValue valueWithPointer:touch];
		NSString *key = [NSString stringWithFormat:@"%@", touchValue];
		
		[squigglesDic setValue:squiggle forKey:key];
		[squiggle release];
		
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *array = [touches allObjects];
	//	NSLog(@"%d  Moved   array %@",[array count],array);
	for(UITouch *touch in array)
	{
		//这里因为在前面 touchBegan中已经存好了相应的key,每一次触摸都有一关键字对应,这里只是在触摸的基础上移动画点
		NSValue *touchValue = [NSValue valueWithPointer:touch];
		
		Squiggle *squiggle = [squigglesDic
							  valueForKey:[NSString stringWithFormat:@"%@",touchValue]];
		CGPoint current = [touch locationInView:self];
		CGPoint previous = [touch previousLocationInView:self];//获取该触摸事件的上一次的触摸坐标
		//一直将当前点加进pointsArray中
		[squiggle addPoint:current];

		//更新后,得声明重新执行下 drawRect方法,系统不会自动执行
		CGPoint lower,higher;
		lower.x = (previous.x > current.x ? current.x : previous.x);
		lower.y = (previous.y > current.y ? current.y : previous.y);
		higher.x = (previous.x < current.x ? current.x : previous.x);
		higher.y = (previous.y < current.y ? current.y : previous.y);
		
		// redraw the screen in the required region
		[self setNeedsDisplayInRect:CGRectMake(lower.x-lineWidth,
											   lower.y-lineWidth, higher.x - lower.x + lineWidth*2,
											   higher.y - lower.y + lineWidth * 2)];
		
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch *touch in touches)
	{
		NSValue *touchValue = [NSValue valueWithPointer:touch];
		NSString *key = [NSString stringWithFormat:@"%@", touchValue];
		Squiggle *squiggle = [squigglesDic valueForKey:key];
		
		[finishSquiggles addObject:squiggle];
		[squigglesDic removeObjectForKey:key];
	}
}

- (void)resetView
{
	[squigglesDic removeAllObjects];
	[finishSquiggles removeAllObjects];
	[self setNeedsDisplay];
}

- (void)dealloc
{
	[squigglesDic release];
	[finishSquiggles release];
	[color release];
	
    [super dealloc];
}

@end
