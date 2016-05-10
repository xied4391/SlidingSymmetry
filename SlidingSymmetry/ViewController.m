//
//  ViewController.m
//  SlidingSymmetry
//
//  Created by Diane Xie on 5/5/16.
//  Copyright © 2016 Diane Xie. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController
NSMutableArray* allImgViews;
NSMutableArray* allCenters;

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    allImgViews = [NSMutableArray new];
    allCenters = [NSMutableArray new];

    int xCen = 96;
    int yCen = 96;
    
    
    for ( int v = 0; v < 4; v++)
    {
        for (int h = 0; h < 4; h++)
        {
        
    UIImageView* myImgView = [[UIImageView alloc] initWithFrame: CGRectMake(300, 234, 192, 192)];
            
    CGPoint curCen = CGPointMake(xCen, yCen);
    [allCenters addObject: [NSValue valueWithCGPoint:curCen]];
            
    myImgView.center = curCen;
    myImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"symmetry_%02i.png", h+v*4]];
    myImgView.userInteractionEnabled = YES;
            [allImgViews addObject:myImgView];
    [self.view addSubview: myImgView];
            xCen += 192;
            
        }
        
        xCen = 96;
        yCen += 192;
        
    }

    [[allImgViews objectAtIndex:0] removeFromSuperview];
    [allImgViews removeObjectAtIndex:0];
    //array with all image views and 16 centers. change to 6*6 at cen = 64 for 96 and +/-=128 for 192
    
    [self randomizeBlocks];
}


CGPoint emptySpot;
-(void)randomizeBlocks

{

    NSMutableArray* centersCopy = [allCenters mutableCopy];
    
    int randLocInt;
    CGPoint randLoc;
    
    for ( UIView *any in allImgViews)
    {
        randLocInt = arc4random() % centersCopy.count;
        randLoc = [[centersCopy objectAtIndex:randLocInt] CGPointValue ];
        
        any.center = randLoc;
        [centersCopy removeObjectAtIndex:randLocInt];
        
    }
   
    emptySpot = [[centersCopy objectAtIndex:0] CGPointValue];
    
}


CGPoint tapCen;
CGPoint left;
CGPoint right;
CGPoint top;
CGPoint bottom;

bool leftisEmpty, rightisEmpty, topisEmpty, bottomisEmpty;

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* myTouch = [[touches allObjects] objectAtIndex:0];
    
    if (myTouch.view !=self.view)

    {
        tapCen = myTouch.view.center;
        
        left = CGPointMake(tapCen.x - 192, tapCen.y);
        right = CGPointMake(tapCen.x + 192, tapCen.y);
        top = CGPointMake(tapCen.x, tapCen.y + 192);
        bottom = CGPointMake(tapCen.x, tapCen.y - 192);
        
        if ( [[NSValue valueWithCGPoint:left] isEqual:[NSValue valueWithCGPoint:emptySpot]]) leftisEmpty = true;
        if ( [[NSValue valueWithCGPoint:right] isEqual:[NSValue valueWithCGPoint:emptySpot]]) rightisEmpty = true;
        if ( [[NSValue valueWithCGPoint:top] isEqual:[NSValue valueWithCGPoint:emptySpot]]) topisEmpty = true;
        if ( [[NSValue valueWithCGPoint:bottom] isEqual:[NSValue valueWithCGPoint:emptySpot]]) bottomisEmpty = true;
        
        
        if (leftisEmpty || rightisEmpty || topisEmpty || bottomisEmpty)
        {
            [UIView beginAnimations:Nil context:NULL];
            [UIView setAnimationDuration:.5];
            myTouch.view.center = emptySpot;
            [UIView commitAnimations];
            emptySpot = tapCen;
            leftisEmpty = false; rightisEmpty = false; topisEmpty = false; bottomisEmpty = false;
        }
        
    }
}




@end
