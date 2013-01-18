//
//  IconSet.h
//  Parity
//
//  Created by Laurent GAIDON on 26/11/12.
//  Copyright (c) 2012 Laurent GAIDON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Icon, Score;

@interface IconSet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * difficulty;
@property (nonatomic, retain) NSSet *icons;
@property (nonatomic, retain) NSOrderedSet *score;
@end

@interface IconSet (CoreDataGeneratedAccessors)

- (void)addIconsObject:(Icon *)value;
- (void)removeIconsObject:(Icon *)value;
- (void)addIcons:(NSSet *)values;
- (void)removeIcons:(NSSet *)values;

- (void)insertObject:(Score *)value inScoreAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScoreAtIndex:(NSUInteger)idx;
- (void)insertScore:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScoreAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScoreAtIndex:(NSUInteger)idx withObject:(Score *)value;
- (void)replaceScoreAtIndexes:(NSIndexSet *)indexes withScore:(NSArray *)values;
- (void)addScoreObject:(Score *)value;
- (void)removeScoreObject:(Score *)value;
- (void)addScore:(NSOrderedSet *)values;
- (void)removeScore:(NSOrderedSet *)values;
@end
