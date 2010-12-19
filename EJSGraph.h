//
//  EJSGraph, a directed graph of arbitrary objects as nodes
//
//  Created by Eric J. Suh on 11/28/10.
//  Copyright 2010 Eric J. Suh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EJSGraph : NSObject <NSCoding, NSFastEnumeration> {
	NSMapTable *neighborLists;
}

+ (id)graphWithSet:(NSSet *)objects;

- (id)initWithSet:(NSSet *)objects;

#pragma mark Accessor Methods

- (NSUInteger)nodeCount;
- (BOOL)containsObject:(id)anObject;
- (BOOL)object:(id)firstObject isConnectedToObject:(id)secondObject;

- (NSSet *)allObjects;
- (NSEnumerator	*)objectEnumerator;
- (NSSet *)neighborsForObject:(id)anObject;
- (NSEnumerator *)neighborEnumeratorForObject:(id)anObject;
- (EJSGraph *)connectedSubgraphContainingObject:(id)anObject;

#pragma mark Modify Network

- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject; // Does nothing if object is not in graph

// If either object is not in the set, they are added
- (void)addEdgeFrom:(id)firstObject to:(id)secondObject;
- (void)removeEdgeFrom:(id)firstObject to:(id)secondObject;

- (void)removeAllEdgesTo:(id)anObject; // Does nothing if object is not in graph
- (void)removeAllEdgesFrom:(id)anObject; // Does nothing if object is not in graph

@end
