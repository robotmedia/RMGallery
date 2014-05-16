//
//  RMGalleryCell.h
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

#import <UIKit/UIKit.h>

/**
 A collection view cell that displays a scrollable image and an activity indicator view.
 */
@interface RMGalleryCell : UICollectionViewCell

/**
 The activity indicator view.
 */
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

/**
 The underlying scroll view used to display the image. Keeps the image centered when smaller than the scroll view.
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

/**
 The image.
 */
@property (nonatomic, strong) UIImage *image;

/**
 Toggles zoom from the given point.
 @param point The point in which to toggle zoom.
 */
- (void)toggleZoomAtPoint:(CGPoint)point;

/**
 Sets the given image as if it had the given size.
 @param image The image to set.
 @param size The size that will be used to calculate the minimum zoom scale.
 @discussion Use this method for placeholder thumbnails that are smaller than the final image.
 */
- (void)setImage:(UIImage *)image inSize:(CGSize)size;

@end
