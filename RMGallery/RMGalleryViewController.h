//
//  RMGalleryViewController.h
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMGalleryView.h"

@interface RMGalleryViewController : UIViewController

@property (nonatomic, readonly) RMGalleryView *galleryView;

@property (nonatomic, assign) NSUInteger galleryIndex;

@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@interface RMGalleryViewController(Sublassing)

- (void)animatingBarsHidden:(BOOL)hidden;

@end
