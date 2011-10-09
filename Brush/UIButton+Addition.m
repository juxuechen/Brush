//
//  UIButton+Addition.m
//  Brush
//
//  Created by chenyang on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIButton+Addition.h"
#import <QuartzCore/QuartzCore.h>

@implementation Button

+ (UIButton *)closeButtonWithTarget:(id)target
{
	UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15.0f, 15.0f)] autorelease];
	
	button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
	
	[button setTitle:@"" forState:UIControlStateNormal];	
	[button setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	
	[button addTarget:target action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
	
    button.backgroundColor = [UIColor whiteColor];
	
	return button;
}

+ (UIButton *)colorButtonWithTarget:(id)target
						   selector:(SEL)selector
							  frame:(CGRect)frame
							  color:(UIColor *)color
								tag:(NSInteger)tag 
{
	UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
	
	button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
	
	[button setTitle:@"" forState:UIControlStateNormal];	
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    button.backgroundColor = color;
	button.tag = tag;
	
	return button;
}

+ (UIButton *)widthButtonWithTarget:(id)target
						   selector:(SEL)selector
							  frame:(CGRect)frame
							  title:(NSString *)title
								tag:(NSInteger)tag
{	
	UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease] ;
	
	[button setTitle:title forState:UIControlStateNormal];	
	
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor whiteColor];
	button.tag = tag;
	
	return button;
}

+ (UIButton *)backImageButtonWithTarget:(id)target
							   selector:(SEL)selector
								  frame:(CGRect)frame
								  image:(NSString *)image
									tag:(NSInteger)tag 
{
	UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease] ;
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	if (0 == tag) {
		[button setBackgroundColor:[UIColor whiteColor]];
	}
	else {
		[button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
	}
	
	button.backgroundColor = [UIColor whiteColor];
	button.tag = tag;
	
	return button;
}

@end
