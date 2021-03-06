//
//  Writing.m
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/16/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "Line.h"
#import "UIBezierPath+Subline.h"



@interface Line()
@property (nonatomic, strong) NSMutableArray   *sublines;
@property (nonatomic, strong) NSMutableArray   *sublineLayers;

@property (nonatomic, strong) LineSmoothHelper   *lineSmoothHelper;

@property (nonatomic)         CGPoint           pastPoint;
@property (nonatomic)         CGPoint           pastMidpoint;

@property (nonatomic)         PenType           penPreference;
@property (nonatomic, strong) UIColor           *penColor;
@property (nonatomic, strong) UIColor           *altcolor;



@end

@implementation Line


-  (UIColor*) altcolor
{
    if(!_altcolor)
    {
        _altcolor = [UIColor blackColor];
    }
    else
    {
        if(_altcolor == [UIColor blackColor])
            _altcolor = [UIColor blueColor];
        else
            _altcolor = [UIColor blackColor];
    }
    return _altcolor;
}

- (instancetype) initWithStartingPoint: (CGPoint) point andPenPreference: (PenType) penPreference andColor: (UIColor *) color
{
    self = [self init];
    
    self.penPreference = penPreference;
    self.penColor = color;
    
    self.pastPoint = point;
    return self;
}

- (NSMutableArray *) sublines
{
    if(!_sublines)
    {
        _sublines = [[NSMutableArray alloc] init];
    }
    return _sublines;
}

- (NSMutableArray *) sublineLayers
{
    if(!_sublineLayers)
    {
        _sublineLayers = [[NSMutableArray alloc] init];
    }
    return _sublineLayers;
}

- (LineSmoothHelper *) lineSmoothHelper
{
    if(!_lineSmoothHelper)
    {
        _lineSmoothHelper = [[LineSmoothHelper alloc] init];
    }
    return _lineSmoothHelper;
}



- (CAShapeLayer *) addConnectedPoint: (CGPoint) point withVelocity: (CGPoint) velocity;
{
    if(![LineSmoothHelper shouldIncludePoint:point afterPoint:self.pastPoint])
        return nil;

    Subline *subline = [self makeSublineAtPoint:point withVelocity:velocity];
    
    
    CAShapeLayer *layer = [self layerWithSubline:subline velocity: velocity];
    UIColor *color = self.altcolor;
    layer.fillColor = color.CGColor;
    layer.strokeColor = color.CGColor;
    
    [self.sublineLayers addObject:layer];
    
    return layer;
}

- (CAShapeLayer *) endLineAtPoint: (CGPoint) point withVelocity: (CGPoint) velocity
{
    Subline *subline = [self makeSublineAtPoint:point withVelocity:velocity];
    CAShapeLayer *layer = [self layerWithSubline:subline velocity:velocity];
    [self.sublineLayers addObject:layer];
    
    UIColor *color = self.altcolor;
    layer.fillColor = color.CGColor;
    layer.strokeColor = color.CGColor;

    
    return layer;
}

- (Subline *) makeSublineAtPoint: (CGPoint) point withVelocity: (CGPoint) velocity
{
    CGPoint midPoint = CGPointMake((point.x + self.pastPoint.x)/2, (point.y + self.pastPoint.y)/2);
    Subline *subline = (!self.sublines.count)?
        [Subline lineToMidpointFromStart:self.pastPoint end:point] :
        [Subline curveFromMidpoint:self.pastMidpoint toMidpoint:midPoint withControl:self.pastPoint];
    self.pastMidpoint = midPoint;
    self.pastPoint = point;
    [self.sublines addObject:subline];
    return subline;
}

- (CAShapeLayer *) layerWithSubline: (Subline *) subline velocity: (CGPoint) velocity
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = subline.CGPath;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = nil;
    layer.lineWidth = [self.lineSmoothHelper lineWidthWithVelocity:velocity andStyle:self.penPreference];
    layer.strokeStart = 0.0;
    layer.strokeEnd = 1.0;
    layer.miterLimit = 0.0;
    layer.lineCap = kCALineCapRound;
    return layer;
}

- (void) undoLine
{
    self.sublines = nil;
    for(CAShapeLayer *layer in self.sublineLayers)
    {
        [layer removeFromSuperlayer];
    }
}

- (CAShapeLayer *) lineLayer
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    for(CAShapeLayer *sublineLayer in self.sublineLayers)
    {
        [layer addSublayer:sublineLayer];
    }
    return layer;
}



@end
