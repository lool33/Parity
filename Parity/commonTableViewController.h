//
//  commonTableViewController.h
//  Parity
//
//  Created by Laurent GAIDON on 27/10/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commonTableViewController : UITableViewController

@property(nonatomic,strong)UIActivityIndicatorView *spinner;


-(void)startSpinner;
-(void)stopSpinner;



@end
