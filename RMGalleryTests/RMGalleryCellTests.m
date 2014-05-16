//
//  RMGalleryCellTests.m
//  RMGallery
//
//  Created by Hermés Piqué on 16/05/14.
//  Copyright (c) 2014 Robot Media. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RMGalleryCell.h"
#import "UIImage+RMGalleryTestUtils.h"

@interface RMGalleryCellTests : XCTestCase

@end

@implementation RMGalleryCellTests {
    RMGalleryCell *_cell;
}

- (void)setUp
{
    [super setUp];
    _cell = [[RMGalleryCell alloc] init];
}

- (void)testInit
{
    RMGalleryCell *cell = [RMGalleryCell new];
    XCTAssertNotNil(cell.scrollView, @"");
    XCTAssertNotNil(cell.activityIndicatorView, @"");
    XCTAssertNil(cell.image, @"");
}

- (void)testSetImage
{
    UIImage *image = [UIImage rm_imageWithSize:CGSizeMake(100, 100)];
    _cell.image = image;
}

- (void)testToggleZoomAtPoint
{
    [_cell toggleZoomAtPoint:CGPointMake(0, 0)];
}

- (void)setImageInSize
{
    UIImage *image = [UIImage rm_imageWithSize:CGSizeMake(100, 100)];
    [_cell setImage:image inSize:CGSizeMake(50, 50)];
}

@end
