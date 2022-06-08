//
//  EPieChart.m
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EPieChart.h"
#import "EColor.h"
#import "UICountingLabel.h"

@implementation EPieChart
@synthesize frontPie = _frontPie;
@synthesize backPie = _backPie;
@synthesize isUpsideDown = _isUpsideDown;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize ePieChartDataModel = _ePieChartDataModel;
@synthesize motionEffectOn = _motionEffectOn;
@synthesize budgetTitle;
@synthesize estimationTitle;
@synthesize graphColor;


- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ePieChartDataModel:nil budgetTitle :@"" secondValueTitle :@"" graphColor:nil detail:@""];
}

- (id)initWithFrame:(CGRect)frame
 ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel budgetTitle : (NSString *)budgetTitleStr secondValueTitle : (NSString *)secondValueTitle graphColor : (UIColor *)graphColorValue detail : (NSString *)detailTitle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isUpsideDown = NO;
        
        if (nil == ePieChartDataModel)
        {
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                             radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5 ];
        }
        else
        {
            _ePieChartDataModel = ePieChartDataModel;
            self.budgetTitle = budgetTitleStr;
            self.estimationTitle = secondValueTitle;
            self.graphColor = graphColorValue;
            //self.ePieChartDataModel.type = type;
            
            
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                              radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5
                                  ePieChartDataModel: _ePieChartDataModel  budgetTitle:self.budgetTitle estimationTitle:self.estimationTitle graphColor:self.graphColor detail:detailTitle];
        }
        
        
        //_frontPie.layer.shadowOffset = CGSizeMake(0, 3);
        //_frontPie.layer.shadowRadius = 5;
       // _frontPie.budgetTitle = self.budgetTitle;
       // _frontPie.layer.shadowColor = EGrey.CGColor;
        //_frontPie.layer.shadowOpacity = 0.8;
        
        [self addSubview:_frontPie];
        
        
        
        _backPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                         radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5 ];
        _backPie.layer.shadowOffset = CGSizeMake(0, 3);
        _backPie.layer.shadowRadius = 5;
        _backPie.layer.shadowColor = EGrey.CGColor;
        _backPie.layer.shadowOpacity = 0.8;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}

- (void) taped:(UITapGestureRecognizer *) tapGestureRecognizer
{
    [self turnPie];

}


- (void)turnPie
{
    [UIView transitionWithView:self
                      duration:0.3
                       options:_isUpsideDown?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^
     {
         if (_isUpsideDown)
         {
             if ([_delegate respondsToSelector:@selector(ePieChart:didTurnToFrontViewWithFrontView:)])
             {
                 [_delegate ePieChart:self didTurnToFrontViewWithFrontView:_frontPie];
             }
             
             [_backPie removeFromSuperview];
             [self addSubview:_frontPie];
         }
         else
         {
             if ([_delegate respondsToSelector:@selector(ePieChart:didTurnToBackViewWithBackView:)])
             {
                 [_delegate ePieChart:self didTurnToBackViewWithBackView:_backPie];
             }
             
             [_frontPie removeFromSuperview];
             [self addSubview:_backPie];
             
         }
         
     } completion:nil];
    
    _isUpsideDown = _isUpsideDown ? NO: YES;
}


#pragma -mark- EPieChart Setter and Getter
- (void)setDelegate:(id<EPieChartDelegate>)delegate
{
    if (delegate && delegate != _delegate)
    {
        _delegate = delegate;
    }
}

- (void)setDataSource:(id<EPieChartDataSource>)dataSource
{
    if (dataSource && dataSource != _dataSource)
    {
        _dataSource = dataSource;
        
        if ([_dataSource respondsToSelector:@selector(backViewForEPieChart:)])
        {
            _backPie.contentView = [_dataSource backViewForEPieChart:self];
        }
        
        if ([_dataSource respondsToSelector:@selector(frontViewForEPieChart:)])
        {
            _frontPie.contentView = [_dataSource frontViewForEPieChart:self];
        }
        
        
    }
}

/** motionEffect supports only iOS7 or higher, So don't turn it on if you are not using it in iOS7.*/
- (void)setMotionEffectOn:(BOOL)motionEffectOn
{
    _motionEffectOn = motionEffectOn;
    if (_motionEffectOn)
    {
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                            type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        
        verticalMotionEffect.minimumRelativeValue = @(-25);
        
        verticalMotionEffect.maximumRelativeValue = @(25);
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        
        horizontalMotionEffect.minimumRelativeValue = @(-25);
        
        horizontalMotionEffect.maximumRelativeValue = @(25);
        
        
        
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        [self addMotionEffect:group];
    }
}


@end


@interface EPie ()

@property (nonatomic, strong) CAShapeLayer *circleBudget;
@property (nonatomic, strong) CAShapeLayer *circleCurrent;
@property (nonatomic, strong) CAShapeLayer *circleEstimate;
@property (nonatomic) CGPoint center;

@end

@implementation EPie
@synthesize ePieChartDataModel = _ePieChartDataModel;
@synthesize circleBudget = _circleBudget;
@synthesize circleCurrent = _circleCurrent;
@synthesize circleEstimate = _circleEstimate;
@synthesize center = _center;
@synthesize radius = _radius;
@synthesize budgetColor = _budgetColor;
@synthesize currentColor = _currentColor;
@synthesize estimateColor = _estimateColor;
@synthesize lineWidth = _lineWidth;
@synthesize contentView = _contentView;
@synthesize budgetTitle;
@synthesize estimationTitle;
@synthesize graphColor;



- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.clipsToBounds = YES;
        _center = center;
        _radius = radius;
        
        //self.backgroundColor = EOrange;
        self.backgroundColor = [UIColor clearColor];
        
        
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;

    }
    return self;
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int str_seconds = (totalSeconds*60) % 60;
    
    int seconds = totalSeconds * 60;
    int minutes = (seconds / 60) % 60;
    int hours = seconds / 3600;
    NSLog(@"%@", [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, str_seconds];
}

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
        budgetTitle :(NSString *)budgetTitleStr estimationTitle : (NSString *)estimationTitleStr  graphColor : (UIColor *)graphColorValue detail : (NSString *)detailTitle

{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.clipsToBounds = YES;
        /** Default settings*/
        _budgetColor = [UIColor whiteColor];
        _currentColor = EYellow;
        _estimateColor = [EYellow colorWithAlphaComponent:0.3];;
        _lineWidth = radius / 6;
        self.budgetTitle = budgetTitleStr;
        self.estimationTitle = estimationTitleStr;
        self.graphColor = graphColorValue;
        
        
        NSLog(@"Budget title in const %@",self.budgetTitle);
        
        
        
        
        _center = center;
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        _ePieChartDataModel = ePieChartDataModel;
        
        /** Default Content View*/
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.clipsToBounds = YES;
        
        UILabel *title = [[UILabel alloc] initWithFrame:self.frame];
        
        title.text = detailTitle;
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont fontWithName:@"DroidArabicKufi" size:15];
        //title.textColor = [[UIColor alloc] initWithRed:200/255 green:200/255 blue:200/255 alpha:1.0];
        //title.textColor = [UIColor redColor];
        //title.textColor = [[UIColor alloc] initWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
        title.textColor = [UIColor colorWithRed:(102/255.f) green:(102/255.f) blue:(102/255.f) alpha:1.0];
        //self.statusTextLabel.textColor = [UIColor colorWithRed:(233/255.f) green:(138/255.f) blue:(36/255.f) alpha:1];
                      
        title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.6);
        [_contentView addSubview:title];
        
        //UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0,, <#CGFloat height#>)]
        
        UIView *line = [[UIView alloc] initWithFrame:self.bounds];
        line.backgroundColor = [UIColor whiteColor];
       line.backgroundColor = [UIColor colorWithRed:(102/255.f) green:(102/255.f) blue:(102/255.f) alpha:1.0];
        
        line.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.4, 1);
        
        line.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.8);
        [_contentView addSubview:line];
        
        
        UICountingLabel *budgetLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
        //budgetLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1);
        budgetLabel.textAlignment = NSTextAlignmentCenter;
        budgetLabel.method = UILabelCountingMethodEaseInOut;
        budgetLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:13];
        budgetLabel.textColor = [UIColor colorWithRed:(102/255.f) green:(102/255.f) blue:(102/255.f) alpha:1.0];
        budgetLabel.minimumScaleFactor =  0.4;
        

        
        budgetLabel.format = @"Pending:%.1f";
        //[_contentView addSubview:budgetLabel];
        NSLog(@"Budget : ");
        NSLog(@"%f",_ePieChartDataModel.budget);
        
        [budgetLabel countFrom:0 to:_ePieChartDataModel.budget withDuration:2.0f];
        
        UICountingLabel *currentLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(40,85, 110, 40)];
        
        //currentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1);
        //currentLabel.textAlignment = NSTextAlignmentCenter;
         currentLabel.textAlignment = NSTextAlignmentRight;
        currentLabel.method = UILabelCountingMethodEaseInOut;
        currentLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:13];
        currentLabel.minimumScaleFactor =  0.4;
        
        currentLabel.textColor = [UIColor colorWithRed:(102/255.f) green:(102/255.f) blue:(102/255.f) alpha:1.0];
        
        if (ePieChartDataModel.type == 0) {
            currentLabel.format = @"Performed:%i";
            currentLabel.format = [NSString stringWithFormat:@"%@:%i",self.budgetTitle,(int)(_ePieChartDataModel.current)];
          
            NSLog(@"Type %i",_ePieChartDataModel.type);
            
            
        }
        else {
            NSUInteger h = _ePieChartDataModel.current / 60;
            
            NSString *formattedTime = [NSString stringWithFormat:@"%lu:%i", (unsigned long)h,  (int)_ePieChartDataModel.current];
            NSLog(@"Formatted time %@",formattedTime);
            
            
          //  currentLabel.format = @"Performed:%i";
            currentLabel.format = [NSString stringWithFormat:@"%@:%@",self.budgetTitle,[self timeFormatted:_ePieChartDataModel.current]];
            
//NSLog(@"Type %i",_ePieChartDataModel.type);

        }
        
        //currentLabel.format = @"Performed:%i";
        NSLog(@"Budget title %@",self.budgetTitle);
        
       // currentLabel.format = [NSString stringWithFormat:@"%@:%i",self.budgetTitle,(int)(_ePieChartDataModel.current)];
        
        
        [_contentView addSubview:currentLabel];
        [currentLabel countFrom:0 to:_ePieChartDataModel.current withDuration:2.0f];
        
        UICountingLabel *estimateLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(40, 109, 110, 40)];

        //estimateLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.2);
        estimateLabel.textAlignment = NSTextAlignmentRight;
        estimateLabel.method = UILabelCountingMethodEaseInOut;
        
        estimateLabel.minimumScaleFactor = 10/estimateLabel.font.pointSize;
        
    
        
        estimateLabel.font = [UIFont fontWithName:@"DroidArabicKufi" size:13];
        
        //estimateLabel.textColor = [[UIColor alloc] initWithRed:82/255 green:83/255 blue:82/255 alpha:1.0];
        estimateLabel.textColor = [UIColor colorWithRed:(102/255.f) green:(102/255.f) blue:(102/255.f) alpha:1.0];

        
        //estimateLabel.format = @"Pending:%.1f";
        
        if (ePieChartDataModel.type == 0) {
            estimateLabel.format = @"Performed:%i";
            
            estimateLabel.format = [NSString stringWithFormat:@"%@:%i",self.estimationTitle,(int)_ePieChartDataModel.estimate];
            
            NSLog(@"Type %i",_ePieChartDataModel.type);
            
            
        }
        else {
            NSUInteger h = _ePieChartDataModel.estimate / 60;
            
            NSString *formattedTime = [NSString stringWithFormat:@"%lu:%i", (unsigned long)h,  (int)_ePieChartDataModel.estimate];
            
            //estimateLabel.format = @"Performed:%i";
            estimateLabel.format = [NSString stringWithFormat:@"%@:%@",self.estimationTitle,[self timeFormatted:_ePieChartDataModel.estimate]];
            //NSLog(@"Type %i",_ePieChartDataModel.type);
            
        }
        
       // estimateLabel.format = [NSString stringWithFormat:@"%@:%i",self.estimationTitle,(int)_ePieChartDataModel.estimate];
       // NSLog(@"Estimation title %@",self.estimationTitle);
        
        
        
        [_contentView addSubview:estimateLabel];
        
        
        
        UIView *firstDot = [[UIView alloc] initWithFrame:CGRectMake(160, 100, 10, 10)];
        firstDot.backgroundColor =  graphColor;
        
        UIView *secondDot = [[UIView alloc] initWithFrame:CGRectMake(160, 125, 10, 10)];
        secondDot.backgroundColor =  [UIColor colorWithRed:(199/255.f) green:(198/255.f) blue:(201/255.f) alpha:1.0];
        //ePieChart1?.frontPie.budgetColor = UIColor(red: 199/255, green: 198/255, blue: 201/255, alpha: 1.0)
       
        
        //ePieChart1?.frontPie.estimateColor = UIColor(red: 230/255, green: 79/255, blue: 59/255, alpha: 1.0)

        [_contentView addSubview:firstDot];
        [_contentView addSubview:secondDot];
        

        
        [estimateLabel countFrom:0 to:_ePieChartDataModel.estimate withDuration:2.0f];
        
        [self reloadContent];
        
    }
    return self;
}

#pragma -mark- Setter and Getter
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self reloadContent];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self reloadContent];
}

- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    [self reloadContent];
}

-(void)setBudgetColor:(UIColor *)budgetColor
{
    _budgetColor = budgetColor;
    [self reloadContent];
}

- (void)setEstimateColor:(UIColor *)estimateColor
{
    _estimateColor = estimateColor;
    [self reloadContent];
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView)
    {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:_contentView];
        
        NSLog(@"_contentView %@", NSStringFromCGRect(_contentView.frame));
        NSLog(@"self %@", NSStringFromCGRect(self.frame));
    }
}




- (void) reloadContent
{
    UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                    radius: _radius * 0.8
                                                                startAngle: 0
                                                                  endAngle: 2 * M_PI
                                                                 clockwise:NO];
    if (!_circleBudget)
        _circleBudget = [CAShapeLayer layer];
    _circleBudget.path = circleBudgetPath.CGPath;
    _circleBudget.fillColor = [UIColor clearColor].CGColor;
    _circleBudget.strokeColor = _budgetColor.CGColor;
    _circleBudget.lineCap = kCALineCapRound;
    _circleBudget.lineWidth = _lineWidth;
    _circleBudget.zPosition = -1;
    
    UIBezierPath* circleCurrentPath = [UIBezierPath bezierPathWithArcCenter: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                     radius: _radius * 0.8
                                                                 startAngle: M_PI_2 * 3
                                                                   endAngle: M_PI_2 * 3 - (_ePieChartDataModel.current / _ePieChartDataModel.budget) * (M_PI * 2)
                                                                  clockwise: NO];
    if (!_circleCurrent)
        _circleCurrent = [CAShapeLayer layer];
    _circleCurrent.path = circleCurrentPath.CGPath;
    _circleCurrent.fillColor = [UIColor clearColor].CGColor;
    _circleCurrent.strokeColor = _currentColor.CGColor;
    _circleCurrent.lineCap = kCALineCapRound;
    _circleCurrent.lineWidth = _lineWidth;
    _circleCurrent.zPosition = 1;
    
    UIBezierPath* circleEstimatePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                      radius: _radius * 0.8
                                                                  startAngle: M_PI_2 * 3
                                                                    endAngle: M_PI_2 * 3 - (_ePieChartDataModel.estimate / _ePieChartDataModel.budget) * (M_PI * 2)
                                                                   clockwise:NO];
    if (!_circleEstimate)
        _circleEstimate = [CAShapeLayer layer];
    _circleEstimate.path = circleEstimatePath.CGPath;
    _circleEstimate.fillColor = [UIColor clearColor].CGColor;
    _circleEstimate.strokeColor = _estimateColor.CGColor;
    _circleEstimate.lineCap = kCALineCapRound;
    _circleEstimate.lineWidth = _lineWidth;
    _circleEstimate.zPosition = 0;
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_circleCurrent addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    [_circleEstimate addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    
    [self.layer addSublayer:_circleBudget];
    [self.layer addSublayer:_circleCurrent];
    [self.layer addSublayer:_circleEstimate];
    
    
    if (_contentView)
    {
        [self addSubview:_contentView];
    }
    
}

- (void) reloadContentWithEPieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    _ePieChartDataModel = ePieChartDataModel;
    [self reloadContent];
}

@end


@implementation EPieChartDataModel
@synthesize current = _current;
@synthesize budget = _budget;
@synthesize estimate = _estimate;


- (id)init
{
    self = [super init];
    if (self)
    {
        _budget = 100;
        _current = 40;
        _estimate = 80;
    }
    return self;
}

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate
            type : (int) type
{
    self = [self init];
    if (self)
    {
        _budget = budget;
        _current = current;
        _estimate = estimate;
        _type = type;
        
    }
    return self;
}



@end
