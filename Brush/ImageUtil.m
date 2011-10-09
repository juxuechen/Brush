//
//  MainViewController.m
//  Brush
//
//  Created by chenyang on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageUtil.h"

#include <sys/time.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

// 返回一个使用RGBA通道的位图上下文 
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage) 
{
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
	int bitmapByteCount; 
	int bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage); 
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	//分配足够容纳图片字节数的内存空间
	bitmapData = malloc( bitmapByteCount ); 
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
	context = CGBitmapContextCreate (bitmapData, 
																	 pixelsWide, 
																	 pixelsHigh, 
																	 8, 
																	 bitmapBytesPerRow, 
																	 colorSpace, 
																	 kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage) 
{
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
    //使用上面的函数创建上下文
	CGContextRef cgctx = CreateRGBABitmapContext(img); 
	
	CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
	CGContextDrawImage(cgctx, rect, img); 
	unsigned char *data = CGBitmapContextGetData (cgctx); 
    //释放上面的函数创建的上下文
	CGContextRelease(cgctx);
	return data;
}

//修改RGB的值
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f){
    int redV=*red;
    int greenV=*green;
    int blueV=*blue;
    int alphaV=*alpha;
    
    *red=f[0]*redV+f[1]*greenV+f[2]*blueV+f[3]*alphaV+f[4];
    *green=f[0+5]*redV+f[1+5]*greenV+f[2+5]*blueV+f[3+5]*alphaV+f[4+5];
    *blue=f[0+5*2]*redV+f[1+5*2]*greenV+f[2+5*2]*blueV+f[3+5*2]*alphaV+f[4+5*2];
    *alpha=f[0+5*3]*redV+f[1+5*3]*greenV+f[2+5*3]*blueV+f[3+5*3]*alphaV+f[4+5*3];
    if (*red>255) {
        *red=255;
    }
    if(*red<0){
        *red=0;
    }
    if (*green>255) {
        *green=255;
    }
    if (*green<0) {
        *green=0;
    }
    if (*blue>255) {
        *blue=255;
    }
    if (*blue<0) {
        *blue=0;
    }
    if (*alpha>255) {
        *alpha=255;
    }
    if (*alpha<0) {
        *alpha=0;
    }
}

#pragma mark -
@implementation ImageUtil

#pragma mark -
+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*) f
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
    //双层循环按照长宽的像素个数迭代每个像素点
	for(GLuint y = 0;y< h;y++)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) 
		{
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha=(unsigned char)imgPixel[pixOff+3];
			//NSLog(@"1------r=%d,g=%d,b=%d,a=%d,",red,green,blue,alpha);
            changeRGBA(&red, &green, &blue, &alpha, f);
            //NSLog(@"2------r=%d,g=%d,b=%d,a=%d,",red,green,blue,alpha);
            //NSLog(@"--------------------------------------");
            //回写数据
			imgPixel[pixOff] = red;
			imgPixel[pixOff+1] = green;
			imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            
            //将数组的索引指向下四个元素
			pixOff += 4;
		}
		wOff += w * 4;
	}
	
	NSInteger dataLength = w*h* 4;
    //下面的代码创建要输出的图像的相关参数
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	//创建要输出的图像
	CGImageRef imageRef = CGImageCreate(w, h, 
                                        bitsPerComponent, 
                                        bitsPerPixel, 
                                        bytesPerRow, 
                                        colorSpaceRef, 
                                        bitmapInfo, 
                                        provider, 
                                        NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

//波普
+ (UIImage*)bopo:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	//printf("w:%d,h:%d",w,h);
	
	int i, j, m, n;
	int bRowOff;
	int width = 8;
	int height = 8;
	int centerW = width /2;
	int centerH = height /2;
	
	//fix the image to right size
	int modw = w%width;
	int modh = h%height;
	if(modw)	w = w - modw;
	if(modh)	h = h - modh;
	
	int br, bg, bb;
	int tr, tg, tb;
	
	double offset;
	//double **weight= malloc(height*width*sizeof(double));
	NSMutableArray *wei = [[NSMutableArray alloc] init];
	for(m = 0; m < height; m++)
	{
		NSMutableArray *t1 = [[NSMutableArray alloc] init];
		for(n = 0; n < width; n++)
		{
			[t1 addObject:[NSNull null]];
		}
		[wei	addObject:t1];
		[t1 release];
	}
	
	int total = 0;
	int max = (int)(pow(centerH, 2) + pow(centerW, 2));
	
	for(m = 0; m < height; m++)
	{
		for(n = 0; n < width; n++)
		{
			offset = max - (int)(pow((m - centerH), 2) + pow((n - centerW), 2));
			total += offset;
			//weight[m][n] = offset;
			[[wei objectAtIndex:m] insertObject:[NSNumber numberWithDouble:offset] atIndex:n];
		}
	}
	for(m = 0; m < height; m++)
	{
		for(n = 0; n < width; n++)
		{
			//weight[m][n] = weight[m][n] / total;
			double newVal = [[[wei objectAtIndex:m] objectAtIndex:n] doubleValue]/total;
			[[wei objectAtIndex:m] replaceObjectAtIndex:n 
																				withObject:[NSNumber numberWithDouble:newVal]];
		}
	}
	bRowOff = 0;
	for(j = 0; j < h; j+=height) 
	{
		int bPixOff = bRowOff;
		
		for(i = 0; i < w; i+=width) 
		{
			int bRowOff2 = bPixOff;
			
			tr = tg = tb = 0;
			
			for(m = 0; m < height; m++)
			{
				int bPixOff2 = bRowOff2;
				
				for(n = 0; n < width; n++)
				{
					tr += 255 - imgPixel[bPixOff2];
					tg += 255 - imgPixel[bPixOff2+1];
					tb += 255 - imgPixel[bPixOff2+2];
					
					bPixOff2 += 4;
				}
				
				bRowOff2 += w*4;
			}
			bRowOff2 = bPixOff;
			
			for(m = 0; m < height; m++)
			{
				int bPixOff2 = bRowOff2;
				for(n = 0; n < width; n++)
				{
					
					//offset = weight[m][n];
					offset =  [[[wei objectAtIndex:m] objectAtIndex:n] doubleValue];
					br = 255 - (int)(tr * offset);
					bg = 255 - (int)(tg * offset);
					bb = 255 - (int)(tb * offset);
					
					if(br < 0)
						br = 0;
					if(bg < 0)
						bg = 0;
					if(bb < 0)
						bb = 0;
					imgPixel[bPixOff2] = br;
					imgPixel[bPixOff2 +1] = bg;
					imgPixel[bPixOff2 +2] = bb;
					
					bPixOff2 += 4; // advance background to next pixel
				}
				bRowOff2 += w*4;
			}
			bPixOff += width*4; // advance background to next pixel
		}
		bRowOff += w * height*4;
	}
	[wei release];
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h, 
																			bitsPerComponent, 
																			bitsPerPixel, 
																			bytesPerRow, 
																			colorSpaceRef, 
																			bitmapInfo, 
																			provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}

//扫描线
+(UIImage*)scanLine:(UIImage*)inImage
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;
	
	for(GLuint y = 0;y< h;y+=2)
	{
		pixOff = wOff;
		
		for (GLuint x = 0; x<w; x++) 
		{
			//int alpha = (unsigned char)imgPixel[pixOff];
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int newR,newG,newB;
			int rr = red *2;
			newR = rr > 255 ? 255 : rr;
			int gg = green *2;
			newG = gg > 255 ? 255 : gg;
			int bb = blue *2;
			newB = bb > 255 ? 255 : bb;
			
			imgPixel[pixOff] = newR;
			imgPixel[pixOff+1] = newG;
			imgPixel[pixOff+2] = newB;
			
			pixOff += 4;
		}
		wOff += w * 4 *2;
	}
	
	NSInteger dataLength = w*h* 4;
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * w;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(w, h, 
																			bitsPerComponent, 
																			bitsPerPixel, 
																			bytesPerRow, 
																			colorSpaceRef, 
																			bitmapInfo, 
																			provider, NULL, NO, renderingIntent);
	
	UIImage *my_Image = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	return my_Image;
}
@end
