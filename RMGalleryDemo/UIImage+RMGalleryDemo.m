//
//  UIImage+RMGalleryDemo.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "UIImage+RMGalleryDemo.h"

@implementation UIImage (RMGalleryDemo)

- (UIImage *)demo_imageByScalingByFactor:(CGFloat)scale
{
    const CGSize size = self.size;
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);

    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
