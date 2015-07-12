//
//  CTDynamicTextFieldItem.m
//  StoreHouseDemo
//
//  Created by casa on 7/8/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTDynamicTextFieldViewItem.h"
#import "UIView+LayoutMethods.h"

@interface CTDynamicTextFieldViewItem () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *textField;
@property (nonatomic, strong) CAShapeLayer *dashedLayer;

@end

@implementation CTDynamicTextFieldViewItem

#pragma mark - life cycle
- (instancetype)initWithFontStyle:(CTDynamicTextFieldItemFontStyle)style
{
    self = [super init];
    if (self) {
        [self addSubview:self.textField];
        self.fontStyle = style;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.textField leftInContainer:20 shouldResize:YES];
    [self.textField rightInContainer:20 shouldResize:YES];
    [self.textField topInContainer:4 shouldResize:YES];
    [self.textField bottomInContainer:4 shouldResize:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - public methods
- (void)sizeToFit
{
    if (self.textField.text.length == 0) {
        switch (self.fontStyle) {
            case CTDynamicTextFieldEditBarFontStyleHeader:
                self.frame = CGRectMake(self.x, self.y, self.width, 13+6+8);
                break;
                
            case CTDynamicTextFieldEditBarFontStyleNormal:
                self.frame = CGRectMake(self.x, self.y, self.width, 14+6+8);
                break;
                
            case CTDynamicTextFieldEditBarFontStyleQuote:
                self.frame = CGRectMake(self.x, self.y, self.width, 15+6+8);
                break;
                
            default:
                break;
        }
    } else {
        [self.textField sizeToFit];
        self.frame = CGRectMake(self.x, self.y, self.width, self.textField.height + 8);
    }
}

#pragma mark - private methods
- (void)showDashedLine
{
    if (!self.dashedLayer.superlayer) {
        self.dashedLayer = nil;
        self.dashedLayer = [self dashedBorderWithColor:[[UIColor blueColor] CGColor] frameSize:self.textField.size];
        [self.textField.layer addSublayer:self.dashedLayer];
    }
}

- (void)hideDashedLine
{
    if (self.dashedLayer.superlayer) {
        [self.dashedLayer removeFromSuperlayer];
        self.dashedLayer = nil;
    }
}

- (CAShapeLayer *)dashedBorderWithColor:(CGColorRef)color frameSize:(CGSize)frameSize
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [shapeLayer setBounds:shapeRect];
    [shapeLayer setPosition:CGPointMake(frameSize.width/2,frameSize.height/2)];

    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:color];
    [shapeLayer setLineWidth:3.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
      [NSNumber numberWithInt:3],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:0];
    [shapeLayer setPath:path.CGPath];

    return shapeLayer;
}

#pragma mark - getters and setters
- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.userInteractionEnabled = NO;
        _textField.delegate = self;
        _textField.text = @"testtest";
    }
    return _textField;
}

- (void)setFontStyle:(CTDynamicTextFieldItemFontStyle)fontStyle
{
    _fontStyle = fontStyle;
    switch (fontStyle) {
        case CTDynamicTextFieldEditBarFontStyleHeader:
            _textField.font = [UIFont boldSystemFontOfSize:13];
            break;
            
        case CTDynamicTextFieldEditBarFontStyleNormal:
            _textField.font = [UIFont fontWithName:@"Baskerville" size:14];
            break;
            
        case CTDynamicTextFieldEditBarFontStyleQuote:
            _textField.font = [UIFont fontWithName:@"AvenirNextCondensed-UltraLightItalic" size:15];
            break;
            
        default:
            break;
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    [super setIsSelected:isSelected];
    if (isSelected) {
        [self showDashedLine];
    } else {
        [self hideDashedLine];
    }
}

- (NSInteger)coordinateWidth
{
    return 6;
}

@end
