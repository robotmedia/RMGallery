//
//  RMGalleryTransition.m
//  RMGallery
//
//  Created by Hermés Piqué on 16/04/14.
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

#import "RMGalleryTransition.h"
#import "RMGalleryViewController.h"

@interface UIView(RMGalleryUtils)

@property (nonatomic, readonly) UIColor *rm_opaqueBackgroundColor;

@end

static CGRect RMCGRectAspectFit(CGSize sourceSize, CGSize size)
{
    const CGFloat targetAspect = size.width / size.height;
    const CGFloat sourceAspect = sourceSize.width / sourceSize.height;
    CGRect rect = CGRectZero;
    
    if (targetAspect > sourceAspect)
    {
        rect.size.height = size.height;
        rect.size.width = rect.size.height * sourceAspect;
        rect.origin.x = (size.width - rect.size.width) * 0.5;
    }
    else
    {
        rect.size.width = size.width;
        rect.size.height = rect.size.width / sourceAspect;
        rect.origin.y = (size.height - rect.size.height) * 0.5;
    }
    return CGRectIntegral(rect);
}

@interface RMGalleryCell(RMGalleryTransition)

@property (nonatomic, readonly) UIImageView *imageView; // Implemented in RMGalleryCell.m

@end

@implementation RMGalleryTransition {
    UIImageView *_imageView;
}

- (id)initWithImageView:(UIImageView*)imageView
{
    if (self = [super init])
    {
        _imageView = imageView;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    return viewController.isBeingPresented ? 0.5 : 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSAssert([transitionContext presentationStyle] == UIModalPresentationFullScreen, @"The modalPresentationStyle of the presented view controller must be UIModalPresentationFullScreen.");
    
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (viewController.isBeingPresented)
    {
        [self animateEnterTransition:transitionContext];
    }
    else
    {
        [self animateExitTransition:transitionContext];
    }
}

- (void)animateEnterTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    RMGalleryViewController *galleryViewController = [self galleryViewControllerFromViewController:toViewController];
    NSAssert(galleryViewController, @"The presented view controller must be kind of RMGalleryViewController or be a UINavigationController with a RMGalleryViewController as the top view controller.");
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    const NSUInteger galleryIndex = galleryViewController.galleryIndex;
    
    UIImage *transitionImage = [self transitionImageForIndex:galleryIndex];
    UIImageView *transitionView = [[UIImageView alloc] initWithImage:transitionImage];
    transitionView.contentMode = UIViewContentModeScaleAspectFill;
    transitionView.clipsToBounds = YES;
    
    UIView *fromView = fromViewController.view;
    const CGRect referenceRect = [self transitionRectForIndex:galleryIndex inView:fromView];
    transitionView.frame = [containerView convertRect:referenceRect fromView:fromView];
    
    UIView *coverView = [[UIView alloc] initWithFrame:transitionView.frame];
    coverView.backgroundColor = [self coverColorForIndex:galleryIndex inView:fromView];
    [containerView addSubview:coverView];

    UIView *backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [containerView addSubview:backgroundView];
    
    [containerView addSubview:transitionView];
    
    const NSTimeInterval duration = [self transitionDuration:transitionContext];
    const CGSize estimatedImageSize = [self estimatedImageSizeForIndex:galleryIndex];
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         backgroundView.alpha = 1;
                         
                         const CGRect transitionViewFinalFrame = RMCGRectAspectFit(estimatedImageSize, containerView.bounds.size);
                         transitionView.frame = transitionViewFinalFrame;
                     }
                     completion:^(BOOL finished) {
                         fromView.alpha = 1;
                         [backgroundView removeFromSuperview];
                         [coverView removeFromSuperview];
                         [transitionView removeFromSuperview];
                         
                         UIView *toView = toViewController.view;
                         [containerView addSubview:toView];
                         const CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
                         toView.frame = finalFrame;
                         [toView layoutIfNeeded];
                         
                         RMGalleryView *galleryView = galleryViewController.galleryView;
                         RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:galleryIndex];
                         if (!galleryCell.image)
                         { // Only set image if it wasn't already set in layoutIfNeeded
                             [galleryCell setImage:transitionImage inSize:estimatedImageSize];
                         }
                         
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)animateExitTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    RMGalleryViewController *galleryViewController = [self galleryViewControllerFromViewController:fromViewController];
    NSAssert(galleryViewController, @"The presented view controller must be kind of RMGalleryViewController or be a UINavigationController with a RMGalleryViewController as the top view controller.");
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    toView.alpha = 0;
    [toView layoutIfNeeded];
    
    const NSUInteger galleryIndex = galleryViewController.galleryIndex;
    RMGalleryView *galleryView = galleryViewController.galleryView;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:galleryIndex];
    UIImageView *fromImageView = galleryCell.imageView;
    CGRect transitionViewInitialFrame = RMCGRectAspectFit(fromImageView.image.size, fromImageView.bounds.size);
    transitionViewInitialFrame = [transitionContext.containerView convertRect:transitionViewInitialFrame fromView:fromImageView];
    
    const CGRect referenceRect = [self transitionRectForIndex:galleryIndex inView:toView];
    const CGRect transitionViewFinalFrame = [transitionContext.containerView convertRect:referenceRect fromView:toView];
    
    UIView *coverView = coverView = [[UIView alloc] initWithFrame:referenceRect];
    coverView.backgroundColor = [self coverColorForIndex:galleryIndex inView:toView];
    [toViewController.view addSubview:coverView];

    UIImageView *transitionView = [[UIImageView alloc] initWithImage:fromImageView.image];
    transitionView.contentMode = UIViewContentModeScaleAspectFill;
    transitionView.clipsToBounds = YES;
    transitionView.frame = transitionViewInitialFrame;
    [containerView addSubview:transitionView];
    [fromViewController.view removeFromSuperview];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewController.view.alpha = 1;
                         transitionView.frame = transitionViewFinalFrame;
                     } completion:^(BOOL finished) {
                         [coverView removeFromSuperview];
                         [transitionView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

#pragma mark Utils

- (UIColor*)coverColorForIndex:(NSUInteger)index inView:(UIView*)view
{
    if ([self.delegate respondsToSelector:@selector(galleryTransition:coverColorForIndex:)])
    {
        UIColor *color = [self.delegate galleryTransition:self coverColorForIndex:index];
        if (color) return color;
    }
    
    UIImageView *imageView = [self transitionImageViewForIndex:index];
    if (imageView)
    {
        return imageView.rm_opaqueBackgroundColor;
    }
    return view.rm_opaqueBackgroundColor;
}
                
- (CGSize)estimatedImageSizeForIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(galleryTransition:estimatedSizeForIndex:)])
    {
        return [self.delegate galleryTransition:self estimatedSizeForIndex:index];
    }
    UIImageView *imageView = [self transitionImageViewForIndex:index];
    UIImage *image = imageView.image;
    return image ? image.size : CGSizeZero;
}

- (UIImage*)transitionImageForIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(galleryTransition:transitionImageForIndex:)])
    {
        UIImage *image = [self.delegate galleryTransition:self transitionImageForIndex:index];
        if (image) return image;
    }
    UIImageView *imageView = [self transitionImageViewForIndex:index];
    UIImage *image = imageView.image;
    NSAssert(image, @"The delegate must return an image in galleryTransition:transitionImageForIndex: or indirectly in galleryTransition:transitionImageViewForIndex:.");
    return image;
}

- (UIImageView*)transitionImageViewForIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(galleryTransition:transitionImageViewForIndex:)])
    {
        return [self.delegate galleryTransition:self transitionImageViewForIndex:index];
    }
    return _imageView;
}

- (CGRect)transitionRectForIndex:(NSUInteger)index inView:(UIView*)view
{
    if ([self.delegate respondsToSelector:@selector(galleryTransition:transitionRectForIndex:inView:)])
    {
        return [self.delegate galleryTransition:self transitionRectForIndex:index inView:view];
    }
    UIImageView *imageView = [self transitionImageViewForIndex:index];
    return imageView ? [view convertRect:imageView.bounds fromView:imageView] : CGRectZero;
}

- (RMGalleryViewController*)galleryViewControllerFromViewController:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:RMGalleryViewController.class]) return (RMGalleryViewController*) viewController;

    if ([viewController isKindOfClass:UINavigationController.class])
    {
        UINavigationController *navigationController = (UINavigationController*)viewController;
        UIViewController *topViewController = navigationController.topViewController;
        if ([topViewController isKindOfClass:RMGalleryViewController.class]) return (RMGalleryViewController*) topViewController;
    }
    
    return nil;
}

@end

@implementation UIView(RMGalleryUtils)

- (UIColor*)rm_opaqueBackgroundColor
{
    UIColor *color = self.backgroundColor;
    if (CGColorGetAlpha(color.CGColor) > 0) return color;

    return [self.superview rm_opaqueBackgroundColor];
}

@end
