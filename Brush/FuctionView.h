//
//  FuctionView.h
//  Brush
//
//  Created by chenyang on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface FuctionView : NSObject

+ (void)removeFuctionView:(UIViewController *)viewController;

+ (UIView *)penViewDelegate:(id)delegate selector:(SEL)selector;

+ (UIView *)filterViewDelegate:(id)delegate  selector:(SEL)selector;

+ (UIView *)backImageViewDelegate:(id)delegate  selector:(SEL)selector;



+ (NSArray *)allColorsArray;

+ (NSArray *)allWidthsArray;

+ (NSArray *)allFiltersArray;

+ (NSArray *)allBackImagesArray;


@end
