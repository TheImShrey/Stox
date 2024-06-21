//
//  StatefulViewModellable.swift
//  Upstox
//
//  Created by Shreyash Shah on 23/05/24.
//

import Foundation

/// A type that can be represented as a state for any view
protocol Stateful: Equatable {}

@MainActor
protocol StatefulViewModellable {
    associatedtype State: Stateful
    associatedtype StateChanges
    associatedtype Actions
    typealias StateChangeTrigger = ((StateChanges) -> Void)
    var state: State { get }
    var onStateChange: StateChangeTrigger? { get set }
    
    /// Helper method for `StateChangeTrigger`, always call all `onStateChange` from this one place
    func broadcast(stateChange: StateChanges)
    func trigger(action: Actions)
}

extension StatefulViewModellable {
    func broadcast(stateChange: StateChanges) {
        self.onStateChange?(stateChange)
    }
}
