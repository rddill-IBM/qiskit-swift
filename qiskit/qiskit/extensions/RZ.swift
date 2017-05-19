//
//  RZ.swift
//  qiskit
//
//  Created by Manoel Marques on 5/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Cocoa

/**
 rotation around the z-axis
 */
public final class RZGate: Gate {

    public init(_ theta: Double, _ qubit: QuantumRegisterTuple, _ circuit: QuantumCircuit? = nil) {
        super.init("rz", [theta], [qubit], circuit)
    }

    public override var description: String {
        let theta = String(format:"%.15f",self.params[0])
        return self._qasmif("\(name)(\(theta)) \(self.args[0].identifier)")
    }
}
