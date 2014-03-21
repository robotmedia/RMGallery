//
//  RMGalleryViewController.m
//  RMGallery
//
//  Created by Hermés Piqué on 20/03/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import "RMGalleryViewController.h"
#import "RMGalleryView.h"

@implementation RMGalleryViewController {
    BOOL _barsHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _galleryView = [[RMGalleryView alloc] initWithFrame:self.view.bounds];
    _galleryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_galleryView];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_galleryView.collectionViewLayout invalidateLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Restore bars
    [self setBarsHidden:NO animated:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return _barsHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark Actions

- (void)tapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self setBarsHidden:!_barsHidden animated:YES];
}

#pragma mark Public

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated
{
    _barsHidden = hidden;
    
    UINavigationController *navigationController = self.navigationController;
    UINavigationBar *navigationBar = navigationController.navigationBar;
    UIToolbar *toolbar = navigationController.toolbar;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        navigationBar.alpha = hidden ? 0 : 1;
        toolbar.alpha = hidden ? 0 : 1;
    }];
}

@end
