//
//  placesTableViewController.m
//  Parity
//
//  Created by Laurent GAIDON on 27/10/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "placesTableViewController.h"
#import "FlickrFetcher.h"
#import "helperFlickrData.h"
#import "photosForPlacesTVC.h"

@interface placesTableViewController ()

@property(nonatomic,strong)NSDictionary *placesByCountry;
@property(nonatomic,strong)NSArray *countrys;
@property(nonatomic,strong)NSMutableDictionary *indexSearch;


@end

@implementation placesTableViewController

@synthesize places = _places;
@synthesize placesByCountry = _placesByCountry;
@synthesize countrys = _countrys;
@synthesize indexSearch = _indexSearch;


-(NSMutableDictionary *)indexSearch
{
    
    if(!_indexSearch){
        
        _indexSearch = [[NSMutableDictionary alloc]init];
    }
    return _indexSearch;
}


-(void)sortPlacesByCountry
{
    //create an NSdictionnary to sort the place by country key
    NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
    
    //iterating over the item in the model topPlaces
    for(NSDictionary *place in self.places)
    {
        //retrieve the country into the place name
        NSString *country = [helperFlickrData countryForPlace:place];
        
        //search in the dictionnary if this country exist
        NSMutableArray *places = [placesByCountry objectForKey:country];
        
        if(!places)
        {
            //if country does not exist in the dictionnary then create the table and add it
            places = [NSMutableArray array];
            [placesByCountry setObject:places forKey:country];
        }
        //add the place to the array for that country
        [places addObject:place];
    }
    
    //now set the new model of this controller with the sorted places
    self.placesByCountry = placesByCountry;
    
    //and save the country list (keys of topPlaceByCountry) in alphabetical order using block
    NSArray *countries = [placesByCountry allKeys];
    self.countrys = [countries sortedArrayUsingComparator:^(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    
    
}


-(void)setPlaces:(NSArray *)places
{
    
    if(places !=_places)
    {
        //we sort the array by alphabetical order
        _places = [places sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *string1 = [obj1 objectForKey:FLICKR_PHOTO_PLACE_NAME];
            NSString *string2 = [obj2 objectForKey:FLICKR_PHOTO_PLACE_NAME];
            return [string1 localizedCaseInsensitiveCompare:string2];
        }];
        
        [self sortPlacesByCountry];
        if(self.tableView.window) [self.tableView reloadData];
        
    }
    
}


#pragma mark - View LifeCycle

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.navigationItem.title = @"Select Place";
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self startSpinner];
    dispatch_queue_t downloadQ = dispatch_queue_create("FlickrDownload", nil);
    dispatch_async(downloadQ, ^{
        NSArray *places = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.places = places;
            [self stopSpinner];
        });
        
    });
  //  dispatch_release(downloadQ);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.countrys count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [self.countrys objectAtIndex:section];
    
}

- (NSString *)tableCellIdentfier
{
    return @"Places Cell";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.placesByCountry objectForKey:[self.countrys objectAtIndex:section]] count];
}



-(NSArray *)indexTitleForCountrys:(NSArray *)countrys
{
    
    NSMutableArray *countrysIndexSearchTitle = [NSMutableArray arrayWithCapacity:[countrys count]];
    
    int sectionIndex = 0;
    
    for(NSString *country in countrys)
    {
        
        NSString *countryIndexTitle = [country substringToIndex:1 ];
        if(countryIndexTitle){
            if(![countrysIndexSearchTitle containsObject:countryIndexTitle]){
                [countrysIndexSearchTitle addObject:countryIndexTitle];
                [self.indexSearch setObject:[NSNumber numberWithInt:sectionIndex] forKey:countryIndexTitle];
            }
            sectionIndex += 1;
        }
    }
    if (countrysIndexSearchTitle) return [countrysIndexSearchTitle copy];
    return nil;
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *sectionIndexTitle = [NSMutableArray array];
    
    if(self.countrys){
        sectionIndexTitle = [[self indexTitleForCountrys:self.countrys] copy];
        return sectionIndexTitle;
        
    }else{
        return nil;
        
    }
    
}


-(NSInteger)        tableView:(UITableView *)tableView
  sectionForSectionIndexTitle:(NSString *)title
                      atIndex:(NSInteger)index
{
 
    return [[self.indexSearch objectForKey:title] intValue];    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"";
    CellIdentifier = [self tableCellIdentfier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    
    
    
    //creation of the cell by the super class
    //if bug, check for the cell identifier in the super class (no match with storyboard)
    //UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *place = [[self.placesByCountry objectForKey:[self.countrys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [helperFlickrData titleForPlace:place];
    cell.detailTextLabel.text = [helperFlickrData subtitleForPlace:place];
    
    return cell;
}



#pragma mark - Table view delegate
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
     NSLog(@"here it should segue to the photoTable coming from the didselect method");
    [self performSegueWithIdentifier:@"show photos" sender:self];
}

*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"show photos"])
    {
        
        NSIndexPath *photoIndex = [self.tableView indexPathForSelectedRow];
        NSString *photoStringKey = [self.countrys objectAtIndex:photoIndex.section];
        
        NSDictionary *place = [[self.placesByCountry objectForKey:photoStringKey] objectAtIndex:photoIndex.row];
        
        [segue.destinationViewController setPlace:place];
    }
    
    
}
@end
