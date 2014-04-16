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
    BOOL _initialGalleryIndexSet;
}

@synthesize galleryIndex = _galleryIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _galleryView = [[RMGalleryView alloc] initWithFrame:self.view.bounds];
    _galleryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_galleryView];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_tapGestureRecognizer requireGestureRecognizerToFail:self.galleryView.doubleTapGestureRecognizer];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_initialGalleryIndexSet)
    {
        // In case the gallery index was set before the view was loaded
        self.galleryView.galleryIndex = _galleryIndex;
        _initialGalleryIndexSet = YES;
    }
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

#pragma mark Gestures

- (void)tapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self setBarsHidden:!_barsHidden animated:YES];
}

#pragma mark Public

- (NSUInteger)galleryIndex
{
    return self.galleryView && _initialGalleryIndexSet ? self.galleryView.galleryIndex : _galleryIndex;
}

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated
{
    _barsHidden = hidden;
    
    const BOOL viewControllerBasedStatusBarAppearence = [self.class viewControllerBasedStatusBarAppearence];
    
    if (!viewControllerBasedStatusBarAppearence)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    }
    UINavigationController *navigationController = self.navigationController;
    UINavigationBar *navigationBar = navigationController.navigationBar;
    UIToolbar *toolbar = navigationController.toolbar;
    const NSTimeInterval duration = animated ? UINavigationControllerHideShowBarDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        if (viewControllerBasedStatusBarAppearence)
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        navigationBar.alpha = hidden ? 0 : 1;
        toolbar.alpha = hidden ? 0 : 1;
        
        [self animatingBarsHidden:hidden];
    }];
}

- (void)setGalleryIndex:(NSUInteger)galleryIndex
{
    if (self.galleryView.galleryDataSource)
    {
        self.galleryView.galleryIndex = galleryIndex;
    }
    else
    {
        _galleryIndex = galleryIndex;
    }
}

#pragma mark Utils

+ (BOOL)viewControllerBasedStatusBarAppearence
{
    static NSString *const key = @"UIViewControllerBasedStatusBarAppearance";
    NSNumber *value = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    BOOL viewControllerBasedStatusBarAppaearence = [value boolValue];
    return viewControllerBasedStatusBarAppaearence;
}

@end

@implementation RMGalleryViewController(Sublassing)

- (void)animatingBarsHidden:(BOOL)hidden {}

@end
