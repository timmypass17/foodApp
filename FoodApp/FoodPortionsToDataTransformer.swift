//
//  FoodPortionToDataTransformer.swift
//  FoodApp
//
//  Created by Timmy Nguyen on 3/16/24.
//

import Foundation

class FoodPortionsToDataTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return FoodPortion.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [FoodPortion.self]
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let foodPortions = value as? [FoodPortion] else {
            fatalError("Wrong data type: value must be a [FoodPortion] object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(foodPortions)
    }
}

extension NSValueTransformerName {
    static let foodPortionsToDataTransformer = NSValueTransformerName(rawValue: "FoodPortionsToDataTransformer")
}