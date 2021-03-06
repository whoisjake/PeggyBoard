//
//  PEGBoardViewController.h
//  PeggyBoard
//
//  Created by Jacob Good on 11/4/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEGBoard.h"

@interface PEGBoardViewController : UIViewController

@property (nonatomic, strong) PEGBoard * board;
@property (nonatomic, strong) UIPanGestureRecognizer * panRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer * rightSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer * leftSwipeRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;

@end
