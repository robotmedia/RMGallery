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

@property (nonatomic, weak) id<RMGalleryTransitionDelegate> delegate;

@end

/** 
 Either galleryTransition:transitionImageViewForIndex: or galleryTransition:transitionImageForIndex: and galleryTransition:transitionRectForIndex: must be implemented.
 **/
@protocol RMGalleryTransitionDelegate <NSObject>

@optional

/**
 Returns the image view that will be used as the origin or destination of the transition.
 @discussion If this method is implemented it is not necessary to implement any other.
 */
- (UIImageView*)galleryTransition:(RMGalleryTransition*)transition transitionImageViewForIndex:(NSUInteger)index;

/**
 Returns the image that will be used as the origin of the transition.
 @discussion The transition image will typically be a thumbnail. If the transition image is different than the final image you must implement galleryTransition:estimatedSizeForIndex: to avoid graphical glitches.
 @discussion This method takes precedence over galleryTransition:transitionImageViewForIndex:.
 */
- (UIImage*)galleryTransition:(RMGalleryTransition*)transition transitionImageForIndex:(NSUInteger)index;

/**
 Returns the frame in the given view that will be used as the origin or destination of the transition.
 @discussion This method takes precedence over galleryTransition:transitionImageViewForIndex:.
 */
- (CGRect)galleryTransition:(RMGalleryTransition*)transition transitionRectForIndex:(NSUInteger)index inView:(UIView*)view;

/**
 Returns the estimated size of the final image. If the final image is bigger than the screen the size does not need to be exact but the aspect ratio must be the same to avoid graphical glitches.
 @discussion If this method is not implemented the size of the transition image will be used instead.
 */
- (CGSize)galleryTransition:(RMGalleryTransition*)transition estimatedSizeForIndex:(NSUInteger)index;

/**
 Returns the color to be used to cover the original frame of the transition image.
 @discussion This method takes precedence over the background color of the image view returned in galleryTransition:transitionImageViewForIndex:.
 */
- (UIColor*)galleryTransition:(RMGalleryTransition*)transition coverColorForIndex:(NSUInteger)index;

@end
