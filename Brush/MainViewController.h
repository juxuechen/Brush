//
//  MainViewController.h
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PainterView.h"

#import "SoundEffect.h"


@interface MainViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
	PainterView *_painterView;
	UIToolbar *_toolbar;

	SoundEffect	*selectSound;
	
	UIImage *backImage;

}

@end
