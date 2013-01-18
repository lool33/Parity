//
//  Icon+Fetch.m
//  Parity
//
//  Created by Laurent GAIDON on 26/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "Icon+Fetch.h"
#import "FlickrFetcher.h"
#import "helperFlickrData.h"
#import "IconSet+Fetch.h"

@implementation Icon (Fetch)


+(Icon *)singleIconInManagedObjectContext:(NSManagedObjectContext *)context
                           withFlickrInfo:(NSDictionary *)flickrInfo
{
    
    Icon *icon;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Icon"];
    request.predicate = [NSPredicate predicateWithFormat:@"Icon.unique = %@",[flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    
    NSError *error;
    
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1 || error){
        //error or mulitple entry
        
        NSLog(@"Error with request for Icon entity name search: %@ %@", matches, error);
        
    }else if([matches count] == 0){
        //no icon found so add it
        icon = [NSEntityDescription insertNewObjectForEntityForName:@"Icon" inManagedObjectContext:context];
        icon.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        icon.title = [helperFlickrData titleForPhoto:flickrInfo];
        icon.subtitle = [helperFlickrData subtitleForPhoto:flickrInfo];
        icon.url = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatSquare] absoluteString];
    
    }else{
        //one icon found, return it
        
        icon = [matches lastObject];
        
    }
    
    return icon;
}

+(NSSet *)iconsForIconSet:(NSString *)iconSetName inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    
    NSSet *icons;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"IconSet"];
    request.predicate = [NSPredicate predicateWithFormat:@"IconSet.name = %@",iconSetName];
    
    
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1 || error || [matches count] == 0){
        //error or mulitple entry or no mtch found
        
        NSLog(@"Error with request for IconSet entity name search: %@ %@", matches, error);
        
      }else{
        //one iconSet found, return the corresponding icons
    
          IconSet *requestedIconSet = [matches lastObject];
          
          icons = requestedIconSet.icons;
          
    }

    
    return icons;
    
}

+(Icon *)iconForFlickrInfo:(NSDictionary *)flickrInfo
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Icon *icon;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Icon"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1 || error){
        NSLog(@"Error with request for icon entity unique search: %@ %@", matches, error);
    }else if([matches count] == 0){
        //icon not found, add it.
        icon = [NSEntityDescription insertNewObjectForEntityForName:@"Icon" inManagedObjectContext:context];
        icon.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        icon.title = [helperFlickrData titleForPhoto:flickrInfo];
        icon.subtitle = [helperFlickrData subtitleForPhoto:flickrInfo];
        icon.url = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatSquare] absoluteString];
        
        
    }else{
        //one match found, return it
        icon = [matches lastObject];
    }
    
    return icon;
    
}


@end
