//
//  helperFlickrData.h
//  Parity
//
//  Created by Laurent GAIDON on 29/10/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface helperFlickrData : NSObject

+(NSString *)titleForPhoto:(NSDictionary *)photo;

+(NSString *)subtitleForPhoto:(NSDictionary *)photo;

+(NSString *)titleForPlace:(NSDictionary *)place;

+(NSString *)subtitleForPlace:(NSDictionary *)place;

+(NSString *)countryForPlace:(NSDictionary *)place;



@end
