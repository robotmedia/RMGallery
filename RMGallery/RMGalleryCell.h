//
//  RMGalleryCell.h
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMGalleryCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readonly) UIScrollView *scrollView;

@end
