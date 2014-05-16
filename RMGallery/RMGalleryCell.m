//
//  RMGalleryCell.m
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RMGalleryCell.h"

@interface RMCenteringScrollView : UIScrollView

@end

@interface RMGalleryCell()<UIScrollViewDelegate>

@property (nonatomic, readonly) UIImageView *imageView;

@end

@implementation RMGalleryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[RMCenteringScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        static const CGFloat MaxScale = 1.5;
        _scrollView.maximumZoomScale = MaxScale;
        [self.contentView addSubview:_scrollView];

        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.clipsToBounds = YES;
        [_scrollView addSubview:_imageView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicatorView.hidesWhenStopped = YES;
        [self.contentView addSubview:_activityIndicatorView];
        
        {
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [self.contentView addConstraints:@[centerX, centerY]];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = self.image;
    if (image)
    {
        self.image = image;
    }
}

#pragma mark UICollectionViewCell

- (void)prepareForReuse
{
    self.image = nil;
}

#pragma mark Public

- (void)setImage:(UIImage *)image
{
    [self setImage:image inSize:image.size];
}

- (void)setImage:(UIImage *)image inSize:(CGSize)imageSize
{
    _scrollView.minimumZoomScale = 1;
    _scrollView.zoomScale = 1;
    
    _imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _imageView.image = image;
    _scrollView.contentSize = image.size;
    
    // Calculate Min
    const CGSize viewSize = _scrollView.bounds.size;
    const CGFloat xScale = viewSize.width / imageSize.width;
    const CGFloat yScale = viewSize.height / imageSize.height;
    const CGFloat minScale = MIN(xScale, yScale);
    
	_scrollView.minimumZoomScale = MIN(minScale, 1);
    
    _scrollView.zoomScale = _scrollView.minimumZoomScale;
    
    _scrollView.contentOffset = CGPointZero; // Will be centered
}

- (UIImage*)image
{
    return _imageView.image;
}

#pragma mark Actions

- (void)toggleZoomAtPoint:(CGPoint)point
{
    const CGPoint imagePoint = [_imageView convertPoint:point fromView:self];
    CGFloat minimumZoomScale = _scrollView.minimumZoomScale;
	if (_scrollView.zoomScale > minimumZoomScale)
    { // Zoom out
		[_scrollView setZoomScale:minimumZoomScale animated:YES];
	}
    else
    { // Zoom in
        const CGFloat maximumZoomScale = _scrollView.maximumZoomScale;
        const CGFloat newZoomScale = MIN(minimumZoomScale * 2, maximumZoomScale);
        const CGFloat width = self.bounds.size.width / newZoomScale;
        const CGFloat height = self.bounds.size.height / newZoomScale;
        const CGRect zoomRect = CGRectMake(imagePoint.x - width / 2, imagePoint.x - height / 2, width, height);
        [_scrollView zoomToRect:zoomRect animated:YES];
	}
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end

@implementation RMCenteringScrollView

- (void)setContentOffset:(CGPoint)contentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize scrollViewSize = self.bounds.size;
    
    if (contentSize.width < scrollViewSize.width)
    {
        contentOffset.x = -(scrollViewSize.width - contentSize.width) / 2.0;
    }
    
    if (contentSize.height < scrollViewSize.height)
    {
        contentOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0;
    }

    [super setContentOffset:contentOffset];
}

@end
