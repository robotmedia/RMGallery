//
//  RMGalleryTransition.h
//  RMGallery
//
//  Created by Hermés Piqué on 16/04/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

@import UIKit;

@protocol RMGalleryTransitionDelegate;

@interface RMGalleryTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (id)initWithImageView:(UIImageView *)referenceImageView;

- (id)initWithImage:(UIImage*)image;

@property (nonatomic, weak) id<RMGalleryTransitionDelegate> delegate;

@end

@protocol RMGalleryTransitionDelegate <NSObject>

@optional

- (CGRect)galleryTransition:(RMGalleryTransition*)transition transitionRectForIndex:(NSUInteger)index inView:(UIView*)view;

- (CGSize)galleryTransition:(RMGalleryTransition*)transition sizeForIndex:(NSUInteger)index;

@end

