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

@property (nonatomic,strong) PEGBoard * board;
@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end
