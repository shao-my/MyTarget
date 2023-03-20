//
//  SuffixWrapper.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/14.
//

import Foundation

/*
@propertyWrapper struct Suffix<Unit: MyUnitProtocl & Equatable>: Equatable {
    var wrappedValue: Double
    var unit: Unit
    
    init(wrappedValue: Double, _ unit: Unit) {
        self.wrappedValue = wrappedValue
        self.unit = unit
    }
    
    var projectedValue: Self {
        get { self }
        set { self = newValue }
    }
    
    var description: String {
        //let suffix = unit.isEmpty ? "" : " \(unit)"
        //return wrappedValue.formatted(.number.precision(.fractionLength(0...1))) + suffix
        
        let perferredUnit = Unit.getPerferredUnit()
        let measurement = Measurement(value: wrappedValue, unit: unit.dimension)
        let converted = measurement.converted(to: perferredUnit.dimension)
        //return converted.formatted(.measurement(width: .abbreviated,usage: .asProvided, numberFormatStyle: .number.precision(.fractionLength(0...1))))
        return converted.value.formatted(.number.precision(.fractionLength(0...1))) + " " + perferredUnit.dimension.localizedSymbol
    }
}

extension Suffix: Codable {}
*/
