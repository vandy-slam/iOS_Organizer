//
//  Queue.swift
//  VandyHacks Organizer
//
//  Created by Bruce Brookshire on 11/3/18.
//  Copyright © 2018 bruce-brookshire.com. All rights reserved.
//

import Foundation


public class Queue<T>
{
    ///Node for the linked list implementation of our queue
    private class Node<T> {
        var value: T
        var previous: Node<T>?
        init(value: T) { self.value = value }
    }
    
    ///Front of our queue
    private var front: Node<T>?
    ///Back of our queue
    private var back: Node<T>?
    ///Size of our queue
    private var size: Int = 0
    
    
    ///Inserts the element: T into the queue in a thread safe manner.
    public func insert(_ element: T) {
        
        if front == nil {
            front = Node<T>(value: element)
            back = front
        } else {
            back?.previous = Node<T>(value: element)
            back = back?.previous
        }
        
        size += 1
    }
    
    ///Returns the next element in the queue.
    ///Helper method
    func getNext() -> T {
        let element = front
        
        if size == 1 {
            back = nil
            front = nil
        } else {
            front = front?.previous
        }
        
        size -= 1
        return element!.value
    }
    
    ///Gets the size of the queue. Operation blocks until lock is acquired to provide an accurate size
    /// - returns: Size of the queue
    public func getSize() -> Int {
        return size
    }
}
