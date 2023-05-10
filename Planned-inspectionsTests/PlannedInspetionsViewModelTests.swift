//
import Combine
@testable import Planned_inspections
//  PlannedInspetionsViewModelTests.swift
//  Planned-inspectionsTests
//
//  Created by cai dongyu on 2023/5/10.
//
import XCTest

final class PlannedinspectionsViewModelTests: XCTestCase {
  var model: PlannedInspetionsViewModel!
  var cancellables = Set<AnyCancellable>()
  let plannedInspectionsRepository = MockPlannedInspectionsRepository()

  override func setUp() {
    model = .init(dataRespository: plannedInspectionsRepository)
  }

  func test_GIVEN_availableDate_WHEN_getPlannedInspections_THEN_plannedDataShouldNotBeNil() {
    // Given
    let date = "26"
    let expectedPlannedInspections = PlannedInspections(title: "inspection", subTitle: "4 inspection", plannedCard: [PlannedCardInfo(inspection: [InspectionInfo(title: "title", address: "address", imageURL: "imageURL", bathrooms: 2, bedrooms: 3, parkingSpaces: 4)])])
    // when { plannedInspectionsRepository.get(eq("26")) returns expectedPlannedInspections

    // When
    model.showInspectionsByDate(by: date)

    // Then
    XCTAssertEqual(model.plannedData?.subTitle, expectedPlannedInspections.subTitle)
    XCTAssertEqual(model.plannedData?.title, expectedPlannedInspections.title)
    XCTAssertEqual(model.plannedData?.plannedCard.first?.inspection.first, expectedPlannedInspections.plannedCard.first?.inspection.first)
  }

  func test_GIVEN_unavailableDate_WHEN_getPlannedInspections_THEN_plannedDataShouldBeNil() {
    // Given
    let date = "24"
    // when { plannedInspectionsRepository.get(eq("24")) returns nil

    // When
    model.showInspectionsByDate(by: date)

    // Then
    XCTAssertNil(model.plannedData)
  }

  func test_GIVEN_firstDateIsAvailable_WHEN_showDefaultInspections_THEN_firstDateInspectionShouldBeShown() {
    // Given
    let daysModel = [DaysModel(date: "26", dayofWeek: "dayOfWeek", dayofMonth: "dayOfMonth", planned: true)]
    model.dates = daysModel

    // When
    model.showDefaultInspections()

    // Then
    XCTAssertNotNil(model.plannedData)
  }

  func test_GIVEN_firstDateIsNotAvailable_WHEN_showDefaultInspections_THEN_firstDateInspectionShouldNotBeShown() {
    // GIVEN
    let daysModel: [DaysModel] = []
    model.dates = daysModel

    // When
    model.showDefaultInspections()

    // Then
    XCTAssertNil(model.plannedData)
  }

  func test_GIVEN_PlannedInpectionsIsAvailable_WHEN_fetchData_THEN_PlannedInpectionsShouldBeUsed() {
    // Given
    model.fetchData()

    XCTAssertEqual(model.noEventTips, "123")
    // when
    // model.fetchData()
    // THEN
  }

  func test_GIVEN_PlannedInpectionsIsNotAvailable_WHEN_fetchData_THEN_PlannedInpectionsShouldBeFailed() {
    plannedInspectionsRepository.isSuccess = false

    model.fetchData()

    XCTAssertEqual(model.errorMessage, "解码错误")
  }
}
