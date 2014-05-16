//
//  UIImage+RMGalleryTestUtils.m
//  RMGallery
//
//  Created by Hermés Piqué on 16/05/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "UIImage+RMGalleryTestUtils.h"

@implementation UIImage (RMGalleryTestUtils)

+ (UIImage*)rm_imageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
