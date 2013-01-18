//
//  helperFlickrData.m
//  Parity
//
//  Created by Laurent GAIDON on 29/10/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import "helperFlickrData.h"
#import "FlickrFetcher.h"

@implementation helperFlickrData


+(NSString *)titleForPhoto:(NSDictionary *)photo
{
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    if([title length]) return title;
    
    title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if([title length]) return title;
    
    return @"UNKNOWN PHOTO TITLE";
    
}

+(NSString *)subtitleForPhoto:(NSDictionary *)photo
{
    NSString *title = [helperFlickrData titleForPhoto:photo];
    if([title isEqualToString:@"UNKNOWN PHOTO TITLE"]) return @"";
    
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if([title isEqualToString:subtitle]) return @"";
    
    return subtitle;
    
}

+(NSString *)titleForPlace:(NSDictionary *)place
{
    NSString *title = [place objectForKey:FLICKR_PHOTO_PLACE_NAME];
    
    return [[title componentsSeparatedByString:@", "] objectAtIndex:0];
    
}

+(NSString *)subtitleForPlace:(NSDictionary *)place
{
    NSString *subtitle = [place objectForKey:FLICKR_PLACE_NAME];
    NSArray *subtitlePart = [subtitle componentsSeparatedByString:@", "];
    
    NSRange range;
    range.location = 1;
    range.length = [subtitlePart count] - 1;
    return [[subtitlePart subarrayWithRange:range] componentsJoinedByString:@", "];
    
}

+(NSString *)countryForPlace:(NSDictionary *)place
{

    return [[[place objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}



@end
