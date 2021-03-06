//
//  Signature.h
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Signature : NSObject <NSCoding>

@property (nonatomic)         NSUInteger page;
@property (nonatomic)         CGFloat   scale;
@property (nonatomic, strong) UIImage   *image; // Maximum size image
@property (nonatomic)         CGPoint   position;

@end
