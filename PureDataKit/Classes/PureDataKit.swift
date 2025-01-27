//
//  PureDataKit.swift
//  PureDataKit
//
//  Created by Evangelos Pittas on 01/27/2025.
//  Copyright (c) 2025 Evangelos Pittas. All rights reserved.
//

import Foundation

public class PureDataKit {
    
    // MARK: - Singleton Instance
    public static let shared = PureDataKit()
    
    // MARK: - Initializer
    private init() {

    }
    
    // MARK: - Public Function
    public func demoFunction() {
        print("PureDataCore demo function was called!")
    }
}
