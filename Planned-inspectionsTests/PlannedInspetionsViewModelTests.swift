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
    plannedInspectionsRepository.isSuccess = true
    plannedInspectionsRepository.plannedInspectionsContent = PlannedInspectionsContent(
      dates: [
        DaysModel(date: "Tuesday 25 April", dayofWeek: "Tue", dayofMonth: "25", planned: false),
        DaysModel(date: "Wednesday 26 April", dayofWeek: "Tue", dayofMonth: "26", planned: true),
        DaysModel(date: "Friday 28 April", dayofWeek: "Fri", dayofMonth: "27", planned: true),
      ],
      plannedInspections: [
        PlannedInspections(title: "title1", subTitle: "subTitle1", plannedCard: [
          PlannedCardInfo(timeslot: "10:00 am-4:00 pm", inspection: [
            InspectionInfo(title: "title 1", address: "address 1", imageURL: "url 1", bathrooms: 1, bedrooms: 2, parkingSpaces: 3),
            InspectionInfo(title: "title 2", address: "address 2", imageURL: "url 2", bathrooms: 3, bedrooms: 2, parkingSpaces: 1),
          ]),
        ]),
      ],
      noEventTips: "no Event Tips."
    )

    // WHEN
    model.fetchData()

    // THEN
    XCTAssertEqual(model.dates.count, 3)
    XCTAssertEqual(model.dates[0].date, "Tuesday 25 April")
    XCTAssertEqual(model.dates[0].dayofWeek, "Tue")
    XCTAssertEqual(model.dates[0].dayofMonth, "25")

    XCTAssertEqual(model.plannedInspections.count, 1)
    XCTAssertEqual(model.plannedInspections[0].plannedCard.count, 1)
    XCTAssertEqual(model.plannedInspections[0].title, "title1")
    XCTAssertEqual(model.plannedInspections[0].plannedCard[0].inspection.count, 2)
    XCTAssertEqual(model.plannedInspections[0].plannedCard[0].inspection[0].imageURL, "url 1")

    XCTAssertEqual(model.noEventTips, "no Event Tips.")

    // When
    model.fetchData()

    // Then
    XCTAssertEqual(model.dates.count, 3)
    XCTAssertEqual(model.dates[0].date, "Tuesday 25 April")
    XCTAssertEqual(model.dates[0].dayofWeek, "Tue")
    XCTAssertEqual(model.dates[0].dayofMonth, "25")

    XCTAssertEqual(model.plannedInspections.count, 1)
    XCTAssertEqual(model.plannedInspections[0].plannedCard.count, 1)
    XCTAssertEqual(model.plannedInspections[0].title, "title1")
    XCTAssertEqual(model.plannedInspections[0].plannedCard[0].inspection.count, 2)
    XCTAssertEqual(model.plannedInspections[0].plannedCard[0].inspection[0].imageURL, "url 1")
  }

  func test_GIVEN_PlannedInpectionsIsNotAvailable_WHEN_fetchData_THEN_PlannedInpectionsShouldBeFailed() {
    // Given
    plannedInspectionsRepository.isSuccess = false
    // When
    model.fetchData()
    // Then
    XCTAssertEqual(model.errorMessage, "解码错误")
  }
}
