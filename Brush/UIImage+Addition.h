//
//  UIImage+Addition.h
//  Brush
//
//  Created by chenyang on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (size)

- (UIImage *)scaleImage;

- (UIImage*)imageByCroppingToRect:(CGRect)rect;

@end
