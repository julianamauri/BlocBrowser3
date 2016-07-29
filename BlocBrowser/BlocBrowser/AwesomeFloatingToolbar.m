//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Juliana Mauri on 21/07/2016.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation AwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
            
            
            
          // button.userInteractionEnabled = NO;
            
           
           button.alpha = 0.25;
            
            
            
           NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
           NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
           UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            [button setTitle:titleForThisLabel forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapFired:) forControlEvents:UIControlEventTouchUpInside];
           
        
            //label.textAlignment = NSTextAlignmentCenter;
            
            
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            button.backgroundColor = colorForThisLabel;
            button.titleLabel.textColor = [UIColor whiteColor];
            //label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:button];
        }
        
        self.labels = labelsArray;
        
       for (UIButton *labels in self.labels) {
            [self addSubview:labels];
       }
        
        
        //self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];

        //[self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
}

- (void) tapFired:(UIButton *)recognizer {
    //if (recognizer.state == UIGestureRecognizerStateRecognized) { // #3
    //CGPoint location = [recognizer locationInView:self]; // #4
        //UIView *tappedView = [self hitTest:location withEvent:nil]; // #5
      
        //if ([self.labels containsObject:tappedView]) { // #6
  //  NSString *title = recognizer.currentTitle;
 
        
        NSLog(@"you clicked on button %@", recognizer.currentTitle);
    
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
    //[self.delegate floatingToolbar:didSelectButtonWithTitle:];
                 }
       // }
    }
//}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}


- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat scale = recognizer.scale;
        
        NSLog(@"New scale: %.2f", scale);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToPinchWithScale:scale];
            
         }
        
        [recognizer setScale:1.0];
    }

}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    NSMutableArray *changeColors = [NSMutableArray arrayWithCapacity:self.colors.count];
    
    changeColors[0] = self.colors[1];
    changeColors[1] = self.colors[2];
    changeColors[2] = self.colors[3];
    changeColors[3] = self.colors[0];
    
    self.colors = changeColors;
    
    for (int i=0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        
        label.backgroundColor = self.colors[i];
    }
}

- (void) layoutSubviews {
    // set the frames for the 4 labels
    
    for (UIButton *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Touch Handling



//- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    //CGPoint location = [touch locationInView:self];
    //UIView *subview = [self hitTest:location withEvent:event];
    
    //if ([subview isKindOfClass:[UILabel class]]) {
       // return (UILabel *)subview;
    //} else {
   //     return nil;
    //}
//}


#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.labels objectAtIndex:index];
        button.userInteractionEnabled = enabled;

        button.alpha = enabled ? 1.0 : 0.25;
   }
}

@end
