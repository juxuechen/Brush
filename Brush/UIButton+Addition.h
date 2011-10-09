//
//  UIButton+Addition.h
//  Brush
//
//  Created by chenyang on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface Button

+ (UIButton *)closeButtonWithTarget:(id)target;

+ (UIButton *)colorButtonWithTarget:(id)target
						   selector:(SEL)selector
							  frame:(CGRect)frame
							  color:(UIColor *)color
								tag:(NSInteger)tag;

+ (UIButton *)widthButtonWithTarget:(id)target
						   selector:(SEL)selector
							  frame:(CGRect)frame
							  title:(NSString *)title
								tag:(NSInteger)tag;

+ (UIButton *)backImageButtonWithTarget:(id)target
							   selector:(SEL)selector
								  frame:(CGRect)frame
								  image:(NSString *)image
									tag:(NSInteger)tag;

@end
