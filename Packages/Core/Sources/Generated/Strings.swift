// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

public enum Strings {
  /// Activity (optional)
  public static let activityOptional = Strings.tr("Localizable", "Activity (optional)", fallback: "Activity (optional)")
  /// Add Entry
  public static let addEntry = Strings.tr("Localizable", "Add Entry", fallback: "Add Entry")
  /// Amount
  public static let amount = Strings.tr("Localizable", "Amount", fallback: "Amount")
  /// Balance
  public static let balance = Strings.tr("Localizable", "Balance", fallback: "Balance")
  /// Create
  public static let create = Strings.tr("Localizable", "Create", fallback: "Create")
  /// Create Payout
  public static let createPayout = Strings.tr("Localizable", "Create Payout", fallback: "Create Payout")
  /// Currency
  public static let currency = Strings.tr("Localizable", "Currency", fallback: "Currency")
  /// Date
  public static let date = Strings.tr("Localizable", "Date", fallback: "Date")
  /// Delete
  public static let delete = Strings.tr("Localizable", "Delete", fallback: "Delete")
  /// Done
  public static let done = Strings.tr("Localizable", "Done", fallback: "Done")
  /// Edit
  public static let edit = Strings.tr("Localizable", "Edit", fallback: "Edit")
  /// Edit Payout
  public static let editPayout = Strings.tr("Localizable", "Edit Payout", fallback: "Edit Payout")
  /// Fixed Amount
  public static let fixedAmount = Strings.tr("Localizable", "Fixed Amount", fallback: "Fixed Amount")
  /// Full Payout
  public static let fullPayout = Strings.tr("Localizable", "Full Payout", fallback: "Full Payout")
  /// Generate
  public static let generate = Strings.tr("Localizable", "Generate", fallback: "Generate")
  /// Graph Content
  public static let graphContent = Strings.tr("Localizable", "Graph Content", fallback: "Graph Content")
  /// History
  public static let history = Strings.tr("Localizable", "History", fallback: "History")
  /// Hourly wage
  public static let hourlyWage = Strings.tr("Localizable", "Hourly wage", fallback: "Hourly wage")
  /// Hours
  public static let hours = Strings.tr("Localizable", "Hours", fallback: "Hours")
  /// Hours missing
  public static let hoursMissing = Strings.tr("Localizable", "Hours missing", fallback: "Hours missing")
  /// Income
  public static let income = Strings.tr("Localizable", "Income", fallback: "Income")
  /// Minutes
  public static let minutes = Strings.tr("Localizable", "Minutes", fallback: "Minutes")
  /// No data to display
  public static let noDataToDisplay = Strings.tr("Localizable", "No data to display", fallback: "No data to display")
  /// No Entries
  public static let noEntries = Strings.tr("Localizable", "No Entries", fallback: "No Entries")
  /// Ok
  public static let ok = Strings.tr("Localizable", "Ok", fallback: "Ok")
  /// Payout
  public static let payout = Strings.tr("Localizable", "Payout", fallback: "Payout")
  /// Payout Amount
  public static let payoutAmount = Strings.tr("Localizable", "Payout Amount", fallback: "Payout Amount")
  /// Payouts
  public static let payouts = Strings.tr("Localizable", "Payouts", fallback: "Payouts")
  /// Please specify how many hours you worked.
  public static let pleaseSpecifyHowManyHoursYouWorked = Strings.tr("Localizable", "Please specify how many hours you worked.", fallback: "Please specify how many hours you worked.")
  /// Save
  public static let save = Strings.tr("Localizable", "Save", fallback: "Save")
  /// Settings
  public static let settings = Strings.tr("Localizable", "Settings", fallback: "Settings")
  /// Sheet
  public static let sheet = Strings.tr("Localizable", "Sheet", fallback: "Sheet")
  /// Time
  public static let time = Strings.tr("Localizable", "Time", fallback: "Time")
  /// Total
  public static let total = Strings.tr("Localizable", "Total", fallback: "Total")
  /// When creating a specific payout, the payout amount will be added as a separate entry in the time sheet and all other entries will remain.
  public static let whenCreatingASpecificPayoutThePayoutAmountWillBeAddedAsASeparateEntryInTheTimeSheetAndAllOtherEntriesWillRemain = Strings.tr("Localizable", "When creating a specific payout, the payout amount will be added as a separate entry in the time sheet and all other entries will remain.", fallback: "When creating a specific payout, the payout amount will be added as a separate entry in the time sheet and all other entries will remain.")
  /// Work Times
  public static let workTimes = Strings.tr("Localizable", "Work Times", fallback: "Work Times")
  public enum ThereAreNoEntriesInTheList {
    /// There are no entries in the list. You cannot create an empty payout.
    public static let youCannotCreateAnEmptyPayout = Strings.tr("Localizable", "There are no entries in the list. You cannot create an empty payout.", fallback: "There are no entries in the list. You cannot create an empty payout.")
  }
  public enum WhenCreatingAFullPayoutAllEntriesInTheTimeSheetWillBeRemovedAndArchivedInThePayoutsTab {
    /// When creating a full payout, all entries in the time sheet will be removed and archived in the payouts tab. The generated payout cannot be edited.
    public static let theGeneratedPayoutCannotBeEdited = Strings.tr("Localizable", "When creating a full payout, all entries in the time sheet will be removed and archived in the payouts tab. The generated payout cannot be edited.", fallback: "When creating a full payout, all entries in the time sheet will be removed and archived in the payouts tab. The generated payout cannot be edited.")
  }
}

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}

// swiftlint:enable all