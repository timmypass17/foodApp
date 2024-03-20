//
//  MealPlan+CoreDataProperties.swift
//  FoodApp
//
//  Created by Timmy Nguyen on 3/17/24.
//
//

import Foundation
import CoreData


extension MealPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPlan> {
        return NSFetchRequest<MealPlan>(entityName: "MealPlan")
    }

    @NSManaged public var date_: Date?
    @NSManaged public var meals_: NSSet?

}

// MARK: Generated accessors for meals_
extension MealPlan {

    @objc(addMeals_Object:)
    @NSManaged public func addToMeals_(_ value: Meal)

    @objc(removeMeals_Object:)
    @NSManaged public func removeFromMeals_(_ value: Meal)

    @objc(addMeals_:)
    @NSManaged public func addToMeals_(_ values: NSSet)

    @objc(removeMeals_:)
    @NSManaged public func removeFromMeals_(_ values: NSSet)
    
    var date: Date {
        get { date_ ?? .now }
        set { date_ = newValue }
    }
    
    var meals: [Meal] {
        get { (meals_?.allObjects as! [Meal]).sorted() }
        set { meals_ = NSSet(array: newValue) }
    }
    
    func getTotalNutrients(_ nutrientID: NutrientID) -> Float {
        var nutrientAmount: Float = 0.0
        for meal in meals {
            nutrientAmount += meal.getTotalNutrients(nutrientID)
        }
        return nutrientAmount
    }
}

extension MealPlan : Identifiable {

}

extension MealPlan {
    static let sample: MealPlan = {
        let context = CoreDataStack.shared.context
        let mealPlan = MealPlan(context: context)
        mealPlan.date = Calendar.current.startOfDay(for: .now)
        
        let breakfast = Meal(context: context)
        breakfast.name = "Breakfast"
        breakfast.index = 0
        breakfast.mealPlan = mealPlan
        mealPlan.addToMeals_(breakfast)

        let lunch = Meal(context: context)
        lunch.name = "Lunch"
        lunch.index = 1
        lunch.mealPlan = mealPlan
        mealPlan.addToMeals_(lunch)
        
//        let dinner = Meal(context: context)
//        dinner.name = "Dinner"
//        dinner.index = 2
//        dinner.mealPlan = mealPlan
//        mealPlan.addToMeals_(dinner)
//        
//        let snacks = Meal(context: context)
//        snacks.name = "Snacks"
//        snacks.index = 2
//        snacks.mealPlan = mealPlan
//        mealPlan.addToMeals_(snacks)
        
        return mealPlan
    }()
    
    func printPrettyString() {
//        print("Meal Plan: \(self.date.formatted())")
//        print("Meals Count \(self.meals.count)")
//        for meal in self.meals {
//            print("\(meal.name)")
//            for entry in meal.foodEntries {
//                print("\(entry.food?.description_ ?? "")")
//                print("\(entry.food?.foodPortions.first?.getServingSizeFormatted())")
//
//            }
//        }
    }
}
