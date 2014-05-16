//
//  RMGalleryTransition.h
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

@import UIKit;

@protocol RMGalleryTransitionDelegate;

/**
 Provides a transition between a view controller the displays an image and a gallery view controller.
 */
@interface RMGalleryTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id<RMGalleryTransitionDelegate> delegate;

/**
 Returns a transition with the given image view as target.
 @param imageView The image view to use as the origin or destination of the transition.
 @return An initialized transition or nil if the object couldn't be created.
 @discussion This is a convenience initializer for simple transitions that might not need delegate.
 */
- (id)initWithImageView:(UIImageView*)imageView;

@end

/** 
 Provides the origin and destination of the transition in the view controller that presents the gallery view controller.
 @discussion When not using the convenience image view constructor, either @c galleryTransition:transitionImageViewForIndex: or @c galleryTransition:transitionImageForIndex: and @c galleryTransition:transitionRectForIndex: must be implemented.
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
 @discussion The transition image will typically be a thumbnail. If the transition image is different than the final image you must implement @c galleryTransition:estimatedSizeForIndex: to avoid graphical glitches.
 @discussion This method takes precedence over galleryTransition:transitionImageViewForIndex:.
 */
- (UIImage*)galleryTransition:(RMGalleryTransition*)transition transitionImageForIndex:(NSUInteger)index;

/**
 Returns the frame in the given view that will be used as the origin or destination of the transition.
 @discussion This method takes precedence over @c galleryTransition:transitionImageViewForIndex:.
 */
- (CGRect)galleryTransition:(RMGalleryTransition*)transition transitionRectForIndex:(NSUInteger)index inView:(UIView*)view;

/**
 Returns the estimated size of the final image. If the final image is bigger than the screen the size does not need to be exact but the aspect ratio must be the same to avoid graphical glitches.
 @discussion If this method is not implemented the size of the transition image will be used instead.
 */
- (CGSize)galleryTransition:(RMGalleryTransition*)transition estimatedSizeForIndex:(NSUInteger)index;

/**
 Returns the color to be used to cover the original frame of the transition image.
 @discussion This method takes precedence over the background color of the image view returned in @c galleryTransition:transitionImageViewForIndex:.
 */
- (UIColor*)galleryTransition:(RMGalleryTransition*)transition coverColorForIndex:(NSUInteger)index;

@end
