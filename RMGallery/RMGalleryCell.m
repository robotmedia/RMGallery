//
//  RMGalleryCell.m
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMGalleryCell.h"

@interface RMCenteringScrollView : UIScrollView

@end

@interface RMGalleryCell()<UIScrollViewDelegate>

@end

@implementation RMGalleryCell {
    UIImageView *_imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[RMCenteringScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        static const CGFloat MaxScale = 1.5;
        _scrollView.maximumZoomScale = MaxScale;
        [self.contentView addSubview:_scrollView];

        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.clipsToBounds = YES;
        [_scrollView addSubview:_imageView];
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

#pragma mark Public

- (void)setImage:(UIImage *)image
{
    _scrollView.minimumZoomScale = 1;
    _scrollView.zoomScale = 1;
    
    const CGSize imageSize = image.size;
    _imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _imageView.image = image;
    _scrollView.contentSize = image.size;
    
    // Calculate Min
    const CGSize viewSize = _scrollView.bounds.size;
    const CGFloat xScale = viewSize.width / imageSize.width;
    const CGFloat yScale = viewSize.height / imageSize.height;
    const CGFloat minScale = MIN(xScale, yScale);

	_scrollView.minimumZoomScale = minScale;

    _scrollView.zoomScale = xScale > 1 && yScale > 1 ? 1 : minScale;
    
    _scrollView.contentOffset = CGPointZero; // Will be centered
}

- (UIImage*)image
{
    return _imageView.image;
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
