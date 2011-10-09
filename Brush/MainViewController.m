//
//  MainViewController.m
//  Brush
//
//  Created by chenyang on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Addition.h"
#import "FuctionView.h"
#import "ColorMatrix.h"
#import "ImageUtil.h"
#import "UIButton+Addition.h"

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
		
		self.view.backgroundColor = BackgroundColor;
		
		
		_painterView = [[PainterView alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 280.0f , 420.0f)];
		[self.view addSubview:_painterView];
		
		
		_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 420, 320, 40)];
		_toolbar.barStyle = UIBarStyleDefault;

		[_toolbar setTintColor:BackgroundColor];
		[self.view addSubview:_toolbar];
		
		// Load the sounds
		NSBundle *mainBundle = [NSBundle mainBundle];
		selectSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];
		
		[_toolbar addSubview:[Button backImageButtonWithTarget:self 
													  selector:@selector(pen) 
														 frame:CGRectMake(26.0f, 4.0f, 32.0f, 32.0f) 
														 image:@"pen.png"
														   tag:1]];
		
		[_toolbar addSubview:[Button backImageButtonWithTarget:self 
													  selector:@selector(filter) 
														 frame:CGRectMake(84.0f, 4.0f, 32.0f, 32.0f) 
														 image:@"filter.png"
														   tag:1]];
		
		[_toolbar addSubview:[Button backImageButtonWithTarget:self 
													  selector:@selector(camera) 
														 frame:CGRectMake(144.0f, 4.0f, 32.0f, 32.0f) 
														 image:@"camera.png"
														   tag:1]];
		
		[_toolbar addSubview:[Button backImageButtonWithTarget:self 
													  selector:@selector(save) 
														 frame:CGRectMake(204.0f, 4.0f, 32.0f, 32.0f) 
														 image:@"save.png"
														   tag:1]];
		
		[_toolbar addSubview:[Button backImageButtonWithTarget:self 
													  selector:@selector(clear) 
														 frame:CGRectMake(262.0f, 4.0f, 32.0f, 32.0f) 
														 image:@"clear.png"
														   tag:1]];
    }
    
    return self;
}

- (void)upBackImage{
	UIGraphicsBeginImageContext(_painterView.bounds.size); 
	[_painterView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
	
	backImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	[backImage retain];
}

- (void)closeView{
	[selectSound play];
	[FuctionView removeFuctionView:self];
}

- (void)filter {
	[self closeView];
	[self.view  addSubview:[FuctionView filterViewDelegate:self selector:@selector(changeFilter:)]];
}

- (void)pen {
	[self closeView];
	[self.view addSubview:[FuctionView penViewDelegate:self selector:@selector(changePen:)]];
}

- (void)camera {
	[self closeView];
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
													otherButtonTitles:@"拍个照", @"选个片",@"选个背景吧",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)save {
	[self closeView];
	
	UIGraphicsBeginImageContext(_painterView.bounds.size); 
	[_painterView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
	
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" 
														message:@"保存成功啦～亲可以到相册中查看"  
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"好滴^-^", nil];
	[alertView show];
	[alertView release];
}


- (void)clear
{
	[self closeView];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲～您要删掉神马呢？" 
														message:@"请在下面选择" 
													   delegate:self 
											  cancelButtonTitle:@"算了，不删了" 
											  otherButtonTitles:@"全删啦全重画",@"删掉画笔痕迹",@"删掉背景图片", nil];
	[alertView show];
	[alertView release];
}

- (void)changePen:(id)sender {
	UIButton *btn = sender;
	if (btn.tag < [[FuctionView allWidthsArray] count]) {
		_painterView.lineWidth = [[[FuctionView allWidthsArray] objectAtIndex:btn.tag] intValue];
	}
	else {
		_painterView.color = [[FuctionView allColorsArray] objectAtIndex:(btn.tag - [[FuctionView allWidthsArray] count])];
	}
	
	[FuctionView removeFuctionView:self];
}

- (void)changeFilter:(id)sender {
	[self performSelectorInBackground:@selector(effectChangeOnBg:) withObject:sender];
	
	[FuctionView removeFuctionView:self];
}

- (void)changeBackImage:(id)sender {
	UIButton *btn = sender;
	
	if (0 == btn.tag) {
		_painterView.backgroundColor = [UIColor whiteColor];
	}
	else {
		UIImage *image = [UIImage imageNamed:[[FuctionView allBackImagesArray] objectAtIndex:btn.tag]];
		_painterView.backgroundColor = [UIColor colorWithPatternImage:[image scaleImage]];
	}
	
	[self upBackImage];
	
	[FuctionView removeFuctionView:self];
}


-(void) effectChangeOnBg:(id) sender{
	UIButton *button = (UIButton*)sender;
	
	if(backImage)
	{
        UIImage *outImage = nil;
        switch (button.tag) {
            case 0:
                outImage = backImage;
                break;
            case 1:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_lomo];
                break;
            case 2:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_heibai];
                break;
            case 3:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_huajiu];
                break;
            case 4:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_gete];
                break;
            case 5:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_ruise];
                break;
            case 6:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_danya];
                break;
            case 7:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_jiuhong];
                break;
            case 8:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_qingning];
                break;
            case 9:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_langman];
                break;
            case 10:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_guangyun];
                break;
            case 11:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_landiao];
                break;
            case 12:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_menghuan];
                break;
            case 13:
                outImage = [ImageUtil processImage:backImage withColorMatrix:colormatrix_yese];
                break;
            default:
                break;
        }
        
		if(outImage)
		{
			_painterView.backgroundColor = [UIColor colorWithPatternImage:outImage];
		}
	}
    //[NSThread sleepForTimeInterval:5];
    //调用主线程的方法，更新UI
    [self performSelectorOnMainThread:@selector(endEffectChange) withObject:nil waitUntilDone:YES];
}

-(void)endEffectChange{
    self.view.userInteractionEnabled=YES; 
}

#pragma mark UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1:
		{
			[_painterView resetView];
			_painterView.backgroundColor = [UIColor whiteColor];
		}
		case 2:
			[_painterView resetView];
			break;
		case 3:
			_painterView.backgroundColor = [UIColor whiteColor];
			break;
		default:
			break;
	}
}

#pragma mark  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
		{
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
				imagePicker.delegate = self;
				imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentModalViewController:imagePicker animated:YES];
				[imagePicker release];
			}
		}
			break;
		case 1:
		{
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:imagePicker animated:YES];
			[imagePicker release];
		}
			break;	
		case 2:
		{
			[FuctionView removeFuctionView:self];
			
			[self.view  addSubview:[FuctionView backImageViewDelegate:self 
															 selector:@selector(changeBackImage:)]];
		}
			break;	
		default:
			break;
	}
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[_painterView setBackgroundColor:
	 [UIColor colorWithPatternImage:
	  [[info objectForKey:UIImagePickerControllerOriginalImage] scaleImage]]];
	
	backImage = [[[info objectForKey:UIImagePickerControllerOriginalImage] scaleImage] retain];
	
	[self upBackImage];
	[self dismissModalViewControllerAnimated:NO];
}

- (void)dealloc 
{
    [_painterView release];
	[_toolbar release];
    
    [super dealloc];
}


@end
