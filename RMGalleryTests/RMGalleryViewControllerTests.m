//
//  RMGalleryViewControllerTests.m
//  RMGallery
//
//  Created by Hermés Piqué on 21/05/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RMGalleryViewController.h"

@interface RMGalleryViewControllerTests : XCTestCase

@end

@implementation RMGalleryViewControllerTests

- (void)testInit
{
    RMGalleryViewController *viewController = [[RMGalleryViewController alloc] init];
    XCTAssertNotNil(viewController.galleryView, @"");
}

- (void)testInitWithCoder
{
    NSCoder *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:[NSData data]];
    RMGalleryViewController *viewController = [[RMGalleryViewController alloc] initWithCoder:aDecoder];
    XCTAssertNotNil(viewController.galleryView, @"");
}

- (void)testInitWithNibName
{
    RMGalleryViewController *viewController = [[RMGalleryViewController alloc] initWithNibName:nil bundle:nil];
    XCTAssertNotNil(viewController.galleryView, @"");
}

@end
