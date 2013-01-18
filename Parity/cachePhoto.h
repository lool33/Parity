//
//  cachePhoto.h
//  Parity
//
//  Created by Laurent GAIDON on 01/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

#define MAX_FLICKR_CACHE_SIZE 1024*1024*10  //last value is max size of cache memory in Mo


@interface cachePhoto : NSObject

+ (cachePhoto *)cacheFor:(NSString *)folder; //class method to create an instance of a cache photo located in folder


- (NSURL *)urlForCachedPhoto:(id)photo format:(FlickrPhotoFormat)format;  //return an url of the requested photo id for the specified flickr format
- (NSURL *)urlForCachedPhotoID:(NSString *)photoID format:(FlickrPhotoFormat)format; //return an url of the requested core data photoid's string for the specified flickr format

- (void)cacheData:(NSData *)data ofPhoto:(id)photo format:(FlickrPhotoFormat)format; //save the photo's data in cache memory
- (void)cacheData:(NSData *)data ofPhotoID:(NSString *)photoID format:(FlickrPhotoFormat)format; //save the core data photo's data in cache memory


@end
