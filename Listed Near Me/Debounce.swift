//
//  Debounce.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 11/10/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

public class Debouncer {
    public static let shared = Debouncer()
    private var pendingWorkItem: DispatchWorkItem?
    
    private init() {}

    func perform(afterDelayMs delay: Int, _ action: @escaping () -> Void) {
        pendingWorkItem?.cancel()
        pendingWorkItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: pendingWorkItem!)
    }
}
