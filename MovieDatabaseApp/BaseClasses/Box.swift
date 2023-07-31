//
//  Box.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 29/07/23.
//

import Foundation

class Box<T>{
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
    }
}
