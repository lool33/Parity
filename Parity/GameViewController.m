//
//  GameViewController.m
//  Parity
//
//  Created by Laurent GAIDON on 10/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController () <UIAlertViewDelegate>



@end




@implementation GameViewController


#pragma mark - viewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //create the pause game label with a tapgesture and a target action linked to it
    
    CGRect labelRect = CGRectMake(10, 10, 50,20);
    UILabel *pauseLabel = [[UILabel alloc]initWithFrame:labelRect];
    pauseLabel.text = @"pause";
    pauseLabel.backgroundColor = self.view.backgroundColor;
    pauseLabel.textColor = [UIColor redColor];
    pauseLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pauseTapped:)];
    
    tapGesture.numberOfTapsRequired =1;
    //allow gesture recognition in the UIlabel
    [pauseLabel setUserInteractionEnabled:YES];
    
    [pauseLabel addGestureRecognizer:tapGesture];
    
    [self.view addSubview:pauseLabel];
        
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pause Menu

-(void)pauseTapped:(UITapGestureRecognizer *)gesture
{
    
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)){
    
    
        UIAlertView *pauseMenu = [[UIAlertView alloc]initWithTitle:@"Game Paused"
                                                           message:@"Choose the action you would like"
                                                          delegate:self
                                                 cancelButtonTitle:@"Resume Game"
                                                 otherButtonTitles:@"Exit Game", nil];
        
        
        [pauseMenu show];
        
    
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0){
        
        //Here we should do some additionnal stuff for the game to restart (timer...)
        
    }else if(buttonIndex == 1){
        
        //Additionnaly to dissmiss the game view we probably should reset some stuff here, just think about it
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
       
}


-(NSString *)justToTryGitChanges:(NSString *)GitChanges
{
    NSString *toremove = @"a string to check the gitHub functionnality";
    
    toremove = [toremove stringByAppendingString:@"really strange those stuff with github"];
    
    return toremove;
    
}


@end
