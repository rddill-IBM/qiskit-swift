// Copyright 2017 IBM RESEARCH. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================

import Foundation
import qiskit

/**
 Illustrate compiling several circuits to different backends.
 */
public final class Multiple {

    private static let backend: String = "ibmqx2"

    private static let QPS_SPECS: [String: Any] = [
        "name": "programs",
        "circuits": [
            ["name": "ghz",
            "quantum_registers": [
                ["name": "q","size": 5]
            ],
            "classical_registers": [
                ["name": "c","size": 5]
            ]],
            ["name": "bell",
            "quantum_registers": [
                ["name": "q","size": 5]
            ],
            "classical_registers": [
                ["name": "c","size": 5]
            ]]
        ]
    ]

    //##############################################################
    // Set the device name and coupling map.
    //##############################################################
    private static let coupling_map = [0: [1, 2],
        1: [2],
        2: [],
        3: [2, 4],
        4: [2]]

    private init() {
    }

    //##############################################################
    // Make a quantum program for the GHZ and Bell states.
    //##############################################################
   
    public class func multiple(_ apiToken: String, _ responseHandler: ((Void) -> Void)? = nil) {
        do {
            print()
            print("#################################################################")
            print("Multiple:")
            let qConfig = try Qconfig(APItoken: apiToken)
            let qp = try QuantumProgram(specs: QPS_SPECS)
            guard let ghz = qp.get_circuit("ghz") else { return }
            guard let bell = qp.get_circuit("bell") else { return }
            guard let q = qp.get_quantum_registers("q") else { return }
            guard let c = qp.get_classical_registers("c") else { return }

            // Create a GHZ state
            try ghz.h(q[0])
            for i in 0..<4 {
                try ghz.cx(q[i], q[i+1])
            }
            // Insert a barrier before measurement
            try ghz.barrier()
            // Measure all of the qubits in the standard basis
            for i in 0..<5 {
                try ghz.measure(q[i], c[i])
            }

            // Create a Bell state
            try bell.h(q[0])
            try bell.cx(q[0], q[1])
            try bell.barrier()
            try bell.measure(q[0], c[0])
            try bell.measure(q[1], c[1])

            print(ghz.qasm())
            print(bell.qasm())

            //##############################################################
            // Set up the API and execute the program.
            //##############################################################
            try qp.set_api(token: qConfig.APItoken, url: qConfig.url.absoluteString)

            try qp.compile(["bell"], backend:"local_qasm_simulator", shots:1024)
            try qp.compile(["ghz"], backend:"ibmqx_qasm_simulator", shots:1024,coupling_map:coupling_map)

            qp.run() { (error) in
                do {
                    if error != nil {
                        print(error!.description)
                        responseHandler?()
                        return
                    }
                    // print(try qp.get_counts("bell")) // returns error, don't do this
                    print(try qp.get_counts("bell", backend:"local_qasm_simulator"))
                    print(try qp.get_counts("ghz"))
                    print("multiple end")
                } catch {
                    print(error.localizedDescription)
                }
                responseHandler?()
            }
        } catch {
            print(error.localizedDescription)
            responseHandler?()
        }
    }
}