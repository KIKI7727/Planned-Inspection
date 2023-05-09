//
//  PlannedInspetion.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import Foundation
struct PlannedInspetion: Codable {
  let data: DataClass
}

struct DataClass: Codable {
  let planner: Planner
}

struct Planner: Codable {
  let displayStrings: DisplayStrings
  let dates: [DateElement]
}

struct DateElement: Codable {
  let date: DateDate
  let times: [TimeElement]
}

struct DateDate: Codable {
  let value: String
  let display: Display
}

struct Display: Codable {
  let dayOfMonth, dayOfWeek, longDate: String
}

struct TimeElement: Codable {
  let time: TimeTime
  let entries: [Entry]
}

struct Entry: Codable {
  let title, eventId, source, status: String
  let message: String?
  let address: String
  let listing: Listing
}

struct Listing: Codable {
  let id: String
  let media: Media
  let generalFeatures: GeneralFeatures
  let propertySizes: PropertySizes
}

struct GeneralFeatures: Codable {
  let bathrooms, bedrooms, parkingSpaces: Bathrooms
}

struct Bathrooms: Codable {
  let value: Int
}

struct Media: Codable {
  let mainImage: MainImage
}

struct MainImage: Codable {
  let templatedUrl: String
}

struct PropertySizes: Codable {
  let building, land: Building?
}

struct Building: Codable {
  let displayValue: String
  let sizeUnit: SizeUnit
}

struct SizeUnit: Codable {
  let displayValue: String
}

struct TimeTime: Codable {
  let display, timezone: String
}

struct DisplayStrings: Codable {
  let dateSummary: DateSummary
  let noEvents: NoEvents
  let timezoneAlert: TimezoneAlert
}

struct DateSummary: Codable {
  let numInspectionsTemplatedOne, numInspectionsTemplatedPlural, numAuctionsTemplatedOne, numAuctionsTemplatedPlural: String
  let noAvailableEvents: String
}

struct NoEvents: Codable {
  let forDate, forPlanner: String
}

struct TimezoneAlert: Codable {
  let header, body: String
}
