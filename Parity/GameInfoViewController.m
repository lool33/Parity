//
//  GameInfoViewController.m
//  Parity
//
//  Created by Laurent GAIDON on 10/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "GameInfoViewController.h"
#import "parityHelper.h"
#import "Score+Fetch.h"
#import "IconSet+Fetch.h"

@interface GameInfoViewController () <UITableViewDataSource , UITableViewDelegate>


@end

@implementation GameInfoViewController

@synthesize iconSet = _iconSet;
@synthesize player = _player;


-(void)setPlayer:(NSString *)player
{
    
    if(player != _player)
    {
        
        _player = player;
        [self viewDidLoad];
        
    }
    
}

-(NSString *)player
{
    
    if(!_player)
    {
        
        _player = DEFAULT_PARITY_PLAYER_NAME;
        
    }
    
    return _player;
}



#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //load a label as the title of the Table
    
    UILabel *tableScoreTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    tableScoreTitle.text = @"BEST SCORES";
    tableScoreTitle.backgroundColor = self.view.backgroundColor;
    tableScoreTitle.textColor = [UIColor redColor];
    tableScoreTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tableScoreTitle];
    
    
    
    //load the table View that display the scores in the hight half of the screen
    
    UITableView *scoreTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 320, 185)
                                                          style:UITableViewStylePlain];
    
    scoreTable.delegate = self;
    scoreTable.dataSource = self;
    scoreTable.rowHeight = 30;
    scoreTable.backgroundColor = [UIColor redColor];
    
    
    [self.view addSubview:scoreTable];
    
    
    
    //Core data instantiation
    
    [parityHelper openplayer:self.player usingBlock:^(BOOL success) {
        
        self.iconSet = [IconSet singleIconSetInManagedObjectContext:[parityHelper sharedPlayer:self.player].dataBase.managedObjectContext withName:DEFAULT_PARITY_ICON_SET];
        
        
        [scoreTable reloadData];
        
        
    }];
    
    
    //create the test database for the first time
    [parityHelper createTestDatabase];
    
    
    
        
    

    
    /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     TESTESTESTESTESTESTESTESTESTESTESTESTESTEST
     here I create some score and I store them in NSuser defaults just to check if it's working

    1-score creation
    
    NSArray *easyScores = [NSArray arrayWithObjects:[NSNumber numberWithInt:154],[NSNumber numberWithInt:345], [NSNumber numberWithInt:654], nil];

    
    NSDictionary *overallScores = [NSDictionary dictionaryWithObjectsAndKeys:easyScores, Level_Easy, nil];
    
    
    2-score saving in user dufaults
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:overallScores forKey:SCORES];
    [defaults synchronize];
    
    
    
    [scoresHelper saveScore:[NSNumber numberWithInt:100] ForPlayer:@"Laurent" forLevel:GAME_LEVEL_EASY];
    [scoresHelper saveScore:[NSNumber numberWithInt:150] ForPlayer:@"Laurent" forLevel:GAME_LEVEL_EASY];
    [scoresHelper saveScore:[NSNumber numberWithInt:25] ForPlayer:@"Laurent" forLevel:GAME_LEVEL_EASY];
    [scoresHelper saveScore:[NSNumber numberWithInt:3890] ForPlayer:@"Laurent" forLevel:GAME_LEVEL_EASY];
    [scoresHelper saveScore:[NSNumber numberWithInt:260] ForPlayer:@"Laurent" forLevel:GAME_LEVEL_EASY];
    [scoresHelper saveScore:[NSNumber numberWithInt:27] ForPlayer:@"Clément" forLevel:GAME_LEVEL_EASY];

    end of TESTESTESTESTESTESTESTESTESTESTESTEST
    
    */
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView DataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.iconSet.score count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    
    
    Score *score = [self.iconSet.score objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",score.time];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",score.player];
    return cell;
    
}


#pragma mark - tableView Delegate


@end
