//
//  BaseViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/10/25.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform()
    
}
