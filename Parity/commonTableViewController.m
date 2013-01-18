//
//  commonTableViewController.m
//  Parity
//
//  Created by Laurent GAIDON on 27/10/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "commonTableViewController.h"

@interface commonTableViewController ()

@end

@implementation commonTableViewController

@synthesize spinner = _spinner;


#pragma mark - UI stuff control

-(void)startSpinner
{
    [self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.spinner];
    
}

-(void)stopSpinner
{
    [self.spinner stopAnimating];
    
    //here we set the right bar button item to nil but should load another button if needed
    self.navigationItem.rightBarButtonItem = nil;
    
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//spinner creation
    self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
 
*********************************************************************************************************************************************************************************************************
 ********  Code Below is Table View Data Source and Delegate            **********************************
 *********  It's implemented in each subclass but not by the super class *********************************
 ************But could be used if subclassed are modified ************************************************
********************************************************************************************************************************************************************************************************

 
 
 
-(NSString *)TableCellIdentifier
{
    return @"Cell";
    
}

-(NSString *)tableCellTitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"Title";
}

-(NSString *)tableCellSubtitleForrowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"Subtitle";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    CellIdentifier = [self TableCellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    cell.textLabel.text = [self tableCellTitleForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self tableCellSubtitleForrowAtIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"la sa vient de la super class");
}
*/


@end
