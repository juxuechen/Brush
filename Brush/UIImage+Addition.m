//
//  UIImage+Addition.m
//  Brush
//
//  Created by chenyang on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation  UIImage (size)

- (UIImage *)scaleImage
{ 
	UIImage *image =  [[UIImage alloc] init];
	CGRect rect = CGRectMake(00.0, 0.0, 280.0f , 420.0f);//280.0f , 420.0f 是320＊480的0。875倍
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage*)imageByCroppingToRect:(CGRect)rect {
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
	// or use the UIImage wherever you like
	UIImage *cropedImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropedImage;
}

@end
