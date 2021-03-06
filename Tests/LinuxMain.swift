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

import XCTest
@testable import qiskitTests
import qiskit

// do not show logging less than error
SDKLogger.type = .typeError

XCTMain([
    testCase(AuthenticationTests.allTests),
    testCase(DataStructureTests.allTests),
    testCase(HamiltonianTests.allTests),
    testCase(IBMQuantumExperienceTests.allTests),
    testCase(LocalQasmSimulatorTests.allTests),
    testCase(LocalUnitarySimulatorTests.allTests),
    testCase(PauliTests.allTests),
    testCase(QiskitParserTests.allTests),
    testCase(QiskitProgramTests.allTests),
    testCase(QiskitTests.allTests),
    testCase(QITests.allTests),
    testCase(QuantumOptimizationTests.allTests),
    testCase(QuantumProgramTests.allTests),
    testCase(UnrollerTests.allTests)
])

