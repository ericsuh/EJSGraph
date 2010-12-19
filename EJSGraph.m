//
//  EJSGraph.m
//
//  Created by Eric J. Suh on 11/28/10.
//  Copyright 2010 Benchside. All rights reserved.
//

#import "EJSGraph.h"

@implementation EJSGraph

#pragma mark Class Method

+ (id)graphWithSet:(NSSet *)objects {
	EJSGraph *graph = [[EJSGraph alloc] initWithSet:objects];
	return [graph autorelease];
}

#pragma mark Init and Dealloc Methods

- (id)init {
	return [self initWithSet:[NSSet set]];
}

- (id)initWithSet:(NSSet *)objects {
	if (self = [super init]) {
		neighborLists = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
												  valueOptions:NSMapTableStrongMemory
													  capacity:[objects count]];
		id object;
		for (object in objects) {
			[neighborLists setObject:[NSMutableSet set] forKey:object];
		}
	}
	return self;
}

- (void)dealloc {
	[neighborLists release];
	[super dealloc];
}

#pragma mark Protocol Methods

// NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:neighborLists forKey:@"neighborLists"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		neighborLists = [[decoder decodeObjectForKey:@"neighborLists"] retain];
	}
	return self;
}

// NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
	return [neighborLists countByEnumeratingWithState:state objects:stackbuf count:len];
}

#pragma mark Accessor Methods

- (NSUInteger)nodeCount {
	return [neighborLists count];
}

- (BOOL)containsObject:(id)anObject {
	return ([neighborLists objectForKey:anObject] == nil) ? NO : YES;
}

- (BOOL)object:(id)firstObject isConnectedToObject:(id)secondObject {
	NSSet *neighbors = [neighborLists objectForKey:firstObject];
	if (neighbors)
		return [neighbors containsObject:secondObject];
	return NO;
}

- (NSSet *)allObjects {
	NSMutableSet *allObjects = [[NSMutableSet alloc] init];
	id key;
	for (key in neighborLists)
		[allObjects addObject:key];
	return [allObjects autorelease];
}

- (NSEnumerator *)objectEnumerator {
	return [neighborLists keyEnumerator];
}

- (NSEnumerator *)edgeEnumerator {
	NSMutableArray *edges = [[NSMutableArray alloc] init];
	id object, neighbor;
	for (object in self)
		for (neighbor in [self neighborsForObject:object])
			[edges addObject:[NSArray arrayWithObjects:object, neighbor, nil]];
	return [[edges autorelease] objectEnumerator];
}

- (NSSet *)neighborsForObject:(id)anObject {
	NSSet *neighbors = [neighborLists objectForKey:anObject];
	if (neighbors) {
		return neighbors;
	}
	else {
		return [NSSet set];
	}
}

- (NSEnumerator *)neighborEnumeratorForObject:(id)anObject {
	NSSet *neighbors = [neighborLists objectForKey:anObject];
	if (neighbors) {
		return [neighbors objectEnumerator];
	} else {
		return [[NSSet set] objectEnumerator];
	}
}

- (EJSGraph *)connectedSubgraphContainingObject:(id)anObject {
	EJSGraph *subgraph = [[EJSGraph alloc] init];
	NSMutableSet *toBeProcessed = [[NSMutableSet alloc] initWithObjects:anObject, nil];
	NSMutableSet *processed = [[NSMutableSet alloc] init];
	NSSet *neighbors;
	id currentObject, neighbor;
	
	while ([toBeProcessed count] > 0) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		currentObject = [toBeProcessed anyObject];
		neighbors = [self neighborsForObject:currentObject];
		for (neighbor in neighbors) {
			[subgraph addEdgeFrom:currentObject to:neighbor];
			if ([processed containsObject:neighbor] == NO)
				[toBeProcessed addObject:neighbor];
		}
		[toBeProcessed removeObject:currentObject];
		[processed addObject:currentObject];
		
		[pool drain];
	}
	[toBeProcessed release];
	[processed release];
	return [subgraph autorelease];
}

#pragma mark Modify Graph

- (void)addObject:(id)anObject {
	[neighborLists setObject:[NSMutableSet set] forKey:anObject];
}

- (void)removeObject:(id)anObject {
	[self removeAllEdgesTo:anObject];
	[neighborLists removeObjectForKey:anObject];
}

// If either object is not in the set, they are added
- (void)addEdgeFrom:(id)firstObject to:(id)secondObject {
	[[neighborLists objectForKey:firstObject] addObject:secondObject];
}

// If either object is not in the set, they are added
- (void)removeEdgeFrom:(id)firstObject to:(id)secondObject {
	[[neighborLists objectForKey:firstObject] removeObject:secondObject];
}

// Does nothing if object is not in graph
- (void)removeAllEdgesTo:(id)anObject {
	NSSet *neighbors = [neighborLists objectForKey:anObject];
	if (neighbors) {
		id neighbor;
		for (neighbor in neighbors)
			[[neighborLists objectForKey:neighbor] removeObject:anObject];
	}
}

- (void)removeAllEdgesFrom:(id)anObject {
	[neighborLists setObject:[NSMutableSet set] forKey:anObject];
}

#pragma mark Debugging

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithString:@"(\n\tNodes:\n\t{\n"];
	id object;
	for (object in self) {
		[description appendFormat:@"\t\t%@,\n", object];
	}
	[description appendString:@"\t}\n\tEdges:\n\t{\n"];
	
	NSEnumerator *edgeEnumerator = [self edgeEnumerator];
	NSArray *edge;
	while (edge = [edgeEnumerator nextObject]) {
		[description appendFormat:@"\t\t%@ => $@,\n", [edge objectAtIndex:0], [edge objectAtIndex:1]];
	}
	[description appendString:@"\t}\n)"];
	return description;
}

@end
