//
//  FuctionView.m
//  Brush
//
//  Created by chenyang on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuctionView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Addition.h"

#define RGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]

@implementation FuctionView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (void)removeFuctionView:(UIViewController *)viewController {
	for (UIView *view in viewController.view.subviews) {
		if (view.tag == ColorView || view.tag == WidthView || view.tag == FilterView || view.tag == BackImageView) {
			[view removeFromSuperview];
		}
	}
}

+ (UIView *)penViewDelegate:(id)delegate  selector:(SEL)selector{
	UIView *viewHolder = [[[UIView alloc] initWithFrame:CGRectMake(40.0f, 120.0f, 240.0f, 200.0f)] autorelease];
	viewHolder.backgroundColor = holderColor;
	viewHolder.layer.cornerRadius = 5.0f;
    viewHolder.layer.masksToBounds = YES;
	viewHolder.tag = ColorView;
	
	[viewHolder addSubview:[Button closeButtonWithTarget:delegate]];
	
	float x = 10.0f;
	float y = 15.0f;
	
	NSArray *widthArray = [FuctionView allWidthsArray];
	for (NSString *width in widthArray) {
		[viewHolder addSubview:[Button widthButtonWithTarget:delegate 
												  selector:selector
													 frame:CGRectMake(x, y, 40.0f, 30.0f) 
													 title:[NSString stringWithFormat:@"%@px",width]
													   tag:[widthArray indexOfObject:width]]];
		x += 45.0f;
		
	}
	
	x = 15.0f;
	y = 55.0f;
	
	NSArray *colorArray = [FuctionView allColorsArray];
	for (UIColor *color in colorArray) {
		[viewHolder addSubview:[Button colorButtonWithTarget:delegate
												  selector:selector
													 frame:CGRectMake(x, y, 30.0f, 30.0f) 
													 color:color
													   tag:([colorArray indexOfObject:color]
															+ [[FuctionView allWidthsArray] count])]];
		
		x += 45.0f;
		
		if (x > 200.0f) {
			x = 15.0f;
			y += 50.0f;
		}
	}

	return viewHolder;
}

+ (UIView *)filterViewDelegate:(id)delegate  selector:(SEL)selector {
	UIView *viewHolder = [[[UIView alloc] initWithFrame:CGRectMake(35.0f, 120.0f, 250.0f, 180.0f)] autorelease];
	viewHolder.backgroundColor = holderColor;
	viewHolder.layer.cornerRadius = 5.0f;
    viewHolder.layer.masksToBounds = YES;
	viewHolder.tag = FilterView;
	
	[viewHolder addSubview:[Button closeButtonWithTarget:delegate]];
	
	float x = 10.0f;
	float y = 15.0f;
	
	NSArray *widthArray = [FuctionView allFiltersArray];
	for (NSString *obj in widthArray) {
		[viewHolder addSubview:[Button widthButtonWithTarget:delegate 
												  selector:selector
													 frame:CGRectMake(x, y, 50.0f, 30.0f) 
													 title:obj
													   tag:[widthArray indexOfObject:obj]]];
		
		x += 60.0f;
		
		if (x > 200.0f) {
			x = 10.0f;
			y += 40.0f;
		}
	}
	
	return viewHolder;
}

+ (UIView *)backImageViewDelegate:(id)delegate  selector:(SEL)selector {
	UIView *viewHolder = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 420.0f)] autorelease];
	viewHolder.backgroundColor = holderColor;
	viewHolder.layer.cornerRadius = 5.0f;
    viewHolder.layer.masksToBounds = YES;
	viewHolder.tag = BackImageView;
	
	[viewHolder addSubview:[Button closeButtonWithTarget:delegate]];
	
	float x = 12.5f;
	float y = 0.0f;
	
	NSArray *imagesArray = [FuctionView allBackImagesArray];
	for (NSString *obj in imagesArray) {
		[viewHolder addSubview:[Button backImageButtonWithTarget:delegate 
													  selector:selector 
														 frame:CGRectMake(x, y, 70.0f, 105.0f)  
														 image:obj 
														   tag:[imagesArray indexOfObject:obj]]];
		
		x += 75.0f;
		
		if (x > 260.0f) {
			x = 12.5f;
			y += 105.0f;
		}
		
	}
	
	return viewHolder;
}

+ (NSArray *)allColorsArray{//15
	return [NSArray arrayWithObjects:
			RGB(255,255,255), RGB(255,153,170), RGB(250,235,163), RGB(147,235,137), RGB(184,244,255),
			
			RGB(119,119,119), RGB(32,248,86), RGB(250,192,0), RGB(255,0,0), RGB(0,184,230),
			
			RGB(0,0,0), RGB(199,156,70), RGB(0,179,89), RGB(12,45,117), RGB(102,14,14),
			
			 nil];
}

+ (NSArray *)allWidthsArray{//5
	return [NSArray arrayWithObjects:@"9",@"7",@"5",@"3",@"1", nil];
}

+ (NSArray *)allFiltersArray{//14
	return [NSArray arrayWithObjects:@"原图",@"lomo",@"黑白",@"旧化",@"哥特",@"锐色",
									@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",
									@"梦幻",@"夜色",nil];
}

+ (NSArray *)allBackImagesArray{//14
	return [NSArray arrayWithObjects:@"back1.png",@"back2.png",@"back3.png",@"back4.png",
									@"back5.png",@"back6.png",@"back7.png",@"back8.png",
									@"back9.png",@"back10.png",@"back11.png",@"back12.png",
									@"back13.png",@"back14.png",@"back15.png",@"back16.png",nil];
}

@end











