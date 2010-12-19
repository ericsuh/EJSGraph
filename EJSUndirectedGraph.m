//
//  EJSUndirectedGraph.m
//  EJSGraphDemo
//
//  Created by Eric J. Suh on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EJSUndirectedGraph.h"


@implementation EJSUndirectedGraph

#pragma mark Overrides of EJSGraph Methods

- (void)addEdgeFrom:(id)firstObject to:(id)secondObject {
	[super addEdgeFrom:firstObject to:secondObject];
	[super addEdgeFrom:secondObject to:firstObject];
}

- (void)removeEdgeFrom:(id)firstObject to:(id)secondObject {
	[super removeEdgeFrom:firstObject to:secondObject];
	[super removeEdgeFrom:secondObject to:firstObject];
}

- (void)removeAllEdgesTo:(id)anObject {
	[super removeAllEdgesTo:anObject];
	[super removeAllEdgesFrom:anObject];
}

- (void)removeAllEdgesFrom:(id)anObject {
	[super removeAllEdgesTo:anObject];
	[super removeAllEdgesFrom:anObject];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"EJSDirectedGraph with %lu nodes", (unsigned long)[self nodeCount]];
}

@end
