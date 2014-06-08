//
//  RMGalleryViewController.m
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

#import "RMGalleryViewController.h"
#import "RMGalleryView.h"

@implementation RMGalleryViewController {
    BOOL _barsHidden;
    BOOL _initialGalleryIndexSet;
    UIToolbar *_toolbar;
}

@synthesize galleryIndex = _galleryIndex;

- (id)init
{
    if (self = [super init])
    {
        _galleryView = [RMGalleryView new];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _galleryView = [RMGalleryView new];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        _galleryView = [RMGalleryView new];
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _galleryView.frame = self.view.bounds;
    _galleryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_galleryView];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_tapGestureRecognizer requireGestureRecognizerToFail:self.galleryView.doubleTapGestureRecognizer];
    _tapGestureRecognizer.delegate = self;
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                duration:(NSTimeInterval)duration
{
    _galleryView.scrollEnabled = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromOrientation
{
    _galleryView.scrollEnabled = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_galleryView.collectionViewLayout invalidateLayout];
    [self layoutToolbarForInterfaceOrientation:toInterfaceOrientation];
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

- (void)setToolbarItems:(NSArray *)toolbarItems animated:(BOOL)animated
{
    [super setToolbarItems:toolbarItems animated:animated];
    if (!self.navigationController)
    {
        [self.toolbar setItems:toolbarItems animated:animated];
    }
}

#pragma mark Gestures

- (void)tapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.navigationController)
    {
        [self setBarsHidden:!_barsHidden animated:YES];
    }
    else
    {
        [self dismissGalleryController];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.tapGestureRecognizer)
    { // Do not recognize tap when touching the toolbar
        return _toolbar ? ![touch.view isDescendantOfView:_toolbar] : YES;
    }
    return YES;
}

#pragma mark Toolbar

- (void)layoutToolbarForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!_toolbar) return;
    
    const BOOL landscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    const BOOL isPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    static CGFloat ToolbarHeightDefault = 44;
    static CGFloat ToolbarHeightLandscapePhone = 32;
    const CGFloat height = landscape && isPhone ? ToolbarHeightLandscapePhone : ToolbarHeightDefault;
    const CGRect bounds = self.view.bounds;
    _toolbar.frame = CGRectMake(0, bounds.size.height - height, bounds.size.width, height);
}

- (void)setupToolbar
{
    _toolbar = [UIToolbar new];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_toolbar];
    [self layoutToolbarForInterfaceOrientation:self.interfaceOrientation];
}

- (UIToolbar*)toolbar
{
    if (self.navigationController) return self.navigationController.toolbar;
    if (!_toolbar)
    {
        [self setupToolbar];
    }
    return _toolbar;
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
    const NSTimeInterval duration = animated ? UINavigationControllerHideShowBarDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        if (viewControllerBasedStatusBarAppearence)
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        navigationBar.alpha = hidden ? 0 : 1;
        self.toolbar.alpha = hidden ? 0 : 1;
        
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

#pragma mark Private

- (void)dismissGalleryController
{
    if ([self.delegate respondsToSelector:@selector(galleryViewController:willDismissViewControllerAnimated:)])
    {
        [self.delegate galleryViewController:self willDismissViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(galleryViewController:didDismissViewControllerAnimated:)])
        {
            [self.delegate galleryViewController:self didDismissViewControllerAnimated:YES];
        }
    }];
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
