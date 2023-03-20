//
//  Unit.swift
//  FoodApp
//
//  Created by 邵明易 on 2023/3/10.
//

import SwiftUI

protocol MyUnitProtocl: CaseIterable, Identifiable, View, Codable, RawRepresentable where RawValue == String, AllCases: RandomAccessCollection {
    associatedtype T: Dimension
    
    static var userDefaultsKey: UserDefaults.Key { get }
    static var defaultUint: Self { get }
    
    var dimension: T { get }
}

extension MyUnitProtocl {
    static func getPerferredUnit() -> Self {
        AppStorage(userDefaultsKey).wrappedValue
    }
}

enum MyEnergyUnit: String, MyUnitProtocl {
    static var userDefaultsKey: UserDefaults.Key = .preferredEnergyUnit
    
    static var defaultUint: MyEnergyUnit = .cal
    
    case cal = "大卡"
    
    var dimension: UnitEnergy {
        switch self {
        case .cal:
            return .calories
        }
    }
}

enum MyWeightUnit: String, MyUnitProtocl {
    static var userDefaultsKey: UserDefaults.Key = .preferredWeightUnit
    
    static var defaultUint: MyWeightUnit = .gram
    
    case gram = "g", pound = "lb", ounce
    
    var dimension: UnitMass {
        switch self {
        case .gram:
            return .grams
        case .pound:
            return .pounds
        case .ounce:
            return .ounces
        }
    }
}

extension MyUnitProtocl {
    var body: some View {
        //Text(dimension.symbol).tag(rawValue)
        Text(dimension.localizedSymbol)
    }
}

extension MyUnitProtocl {
    var id: Self { self }
}

extension Unit {
    var localizedSymbol: String {
        MeasurementFormatter().string(from: self)
    }
}
