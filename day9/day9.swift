//
//  day9.swift
//  
//
//  Created by Dornhoth on 23.07.19.
//

import Foundation

struct Edge {
    let from: String
    let to: String
    let distance: Int
}

struct Graph {
    let nodes: [String]
    let edges: [Edge]
}

func getMinAndMaxDistances(graph: Graph) -> [Int] {
    var minDistances = [Int]()
    var maxDistances = [Int]()

    for node in graph.nodes {
        let minAndMax = getMinAndMaxDistancesGivenStart(graph: graph, start: node)
        minDistances.append(minAndMax[0])
        maxDistances.append(minAndMax[1])
    }
    return [minDistances.min()!, maxDistances.max()!]
}

func getMinAndMaxDistancesGivenStart(graph: Graph, start: String) -> [Int] {
    let newNodes = graph.nodes.filter { !$0.elementsEqual(start) }
    let newGraph = Graph(nodes: newNodes, edges: graph.edges)
    
    if newGraph.nodes.count == 1 {
        let edges = newGraph.edges.filter{ $0.from == newGraph.nodes[0] && $0.to == start }
        return [edges[0].distance, edges[0].distance]
    }
    
    var minDistances = [Int]()
    var maxDistances = [Int]()
    for node in newGraph.nodes {
        let distanceToNewGraph = (graph.edges.filter { $0.from == start && $0.to == node })[0].distance
        let minAndMaxDistancesGivenStart = getMinAndMaxDistancesGivenStart(graph: newGraph, start: node)
        minDistances.append(distanceToNewGraph + minAndMaxDistancesGivenStart[0])
        maxDistances.append(distanceToNewGraph + minAndMaxDistancesGivenStart[1])
    }
    return [minDistances.min()!, maxDistances.max()!]
}

func createGraph(str: String) -> Graph {
    var nodes = [String]()
    var edges = [Edge]()
    
    let lines = str.components(separatedBy: "\n")
    for line in lines {
        let firstSplit = line.components(separatedBy: " = ")
        let secondSplit = firstSplit[0].components(separatedBy: " to ")
        let from = secondSplit[0]
        let to = secondSplit[1]

        if !nodes.contains(from) {
            nodes.append(from)
        }
        if !nodes.contains(to){
            nodes.append(to)
        }
        edges.append(Edge(from: from, to: to, distance: Int(firstSplit[1])!))
        edges.append(Edge(from: to, to: from, distance: Int(firstSplit[1])!))
    }
    return Graph(nodes: nodes, edges: edges)
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let graph = createGraph(str: contents)
    let minAndMax = getMinAndMaxDistances(graph: graph)
    print("Result part 1: \(minAndMax[0])")
    print("Result part 2: \(minAndMax[1])")
}
