// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

public enum Strings {
  public enum CreateEntry {
    /// Activity (optional)
    public static let activity = Strings.tr("Localizable", "CREATE_ENTRY.ACTIVITY", fallback: "Activity (optional)")
    /// Amount
    public static let amount = Strings.tr("Localizable", "CREATE_ENTRY.AMOUNT", fallback: "Amount")
    /// Date
    public static let date = Strings.tr("Localizable", "CREATE_ENTRY.DATE", fallback: "Date")
    /// Fixed Amount
    public static let fixedAmount = Strings.tr("Localizable", "CREATE_ENTRY.FIXED_AMOUNT", fallback: "Fixed Amount")
    /// Hourly wage
    public static let hourlyWage = Strings.tr("Localizable", "CREATE_ENTRY.HOURLY_WAGE", fallback: "Hourly wage")
    /// Hours
    public static let hours = Strings.tr("Localizable", "CREATE_ENTRY.HOURS", fallback: "Hours")
    /// Minutes
    public static let minutes = Strings.tr("Localizable", "CREATE_ENTRY.MINUTES", fallback: "Minutes")
    /// Add Entry
    public static let navigationTitle = Strings.tr("Localizable", "CREATE_ENTRY.NAVIGATION_TITLE", fallback: "Add Entry")
    /// Time
    public static let time = Strings.tr("Localizable", "CREATE_ENTRY.TIME", fallback: "Time")
    public enum Alerts {
      public enum AmountMissing {
        /// Please specify a pay amount.
        public static let message = Strings.tr("Localizable", "CREATE_ENTRY.ALERTS.AMOUNT_MISSING.MESSAGE", fallback: "Please specify a pay amount.")
        /// Amount missing
        public static let title = Strings.tr("Localizable", "CREATE_ENTRY.ALERTS.AMOUNT_MISSING.TITLE", fallback: "Amount missing")
      }
      public enum HoursMissing {
        /// Please specify how many hours you worked.
        public static let message = Strings.tr("Localizable", "CREATE_ENTRY.ALERTS.HOURS_MISSING.MESSAGE", fallback: "Please specify how many hours you worked.")
        /// Hours missing
        public static let title = Strings.tr("Localizable", "CREATE_ENTRY.ALERTS.HOURS_MISSING.TITLE", fallback: "Hours missing")
      }
    }
    public enum Keyboard {
      /// +/-
      public static let plusMinus = Strings.tr("Localizable", "CREATE_ENTRY.KEYBOARD.PLUS_MINUS", fallback: "+/-")
    }
  }
  public enum CreatePayout {
    /// Payout Amount
    public static let amount = Strings.tr("Localizable", "CREATE_PAYOUT.AMOUNT", fallback: "Payout Amount")
    /// Amount
    public static let amountHint = Strings.tr("Localizable", "CREATE_PAYOUT.AMOUNT_HINT", fallback: "Amount")
    /// Balance
    public static let balance = Strings.tr("Localizable", "CREATE_PAYOUT.BALANCE", fallback: "Balance")
    /// Date
    public static let date = Strings.tr("Localizable", "CREATE_PAYOUT.DATE", fallback: "Date")
    /// Edit Payout
    public static let editNavigationTitle = Strings.tr("Localizable", "CREATE_PAYOUT.EDIT_NAVIGATION_TITLE", fallback: "Edit Payout")
    /// Full Payout
    public static let fullPayout = Strings.tr("Localizable", "CREATE_PAYOUT.FULL_PAYOUT", fallback: "Full Payout")
    /// Create Payout
    public static let navigationTitle = Strings.tr("Localizable", "CREATE_PAYOUT.NAVIGATION_TITLE", fallback: "Create Payout")
    public enum Alerts {
      public enum EmptyPayout {
        /// There are no entries in the list. You cannot create an empty payout.
        public static let message = Strings.tr("Localizable", "CREATE_PAYOUT.ALERTS.EMPTY_PAYOUT.MESSAGE", fallback: "There are no entries in the list. You cannot create an empty payout.")
        /// No Entries
        public static let title = Strings.tr("Localizable", "CREATE_PAYOUT.ALERTS.EMPTY_PAYOUT.TITLE", fallback: "No Entries")
      }
    }
    public enum Messages {
      /// When creating a full payout, all entries in the time sheet will be removed and archived in the payouts tab. The generated payout cannot be edited.
      public static let fullPayout = Strings.tr("Localizable", "CREATE_PAYOUT.MESSAGES.FULL_PAYOUT", fallback: "When creating a full payout, all entries in the time sheet will be removed and archived in the payouts tab. The generated payout cannot be edited.")
      /// When creating a specific payout, the payout amount will be added as a separate entry in the time sheet and all other entries will remain.
      public static let specificPayout = Strings.tr("Localizable", "CREATE_PAYOUT.MESSAGES.SPECIFIC_PAYOUT", fallback: "When creating a specific payout, the payout amount will be added as a separate entry in the time sheet and all other entries will remain.")
    }
    public enum NavigationBar {
      /// Create
      public static let create = Strings.tr("Localizable", "CREATE_PAYOUT.NAVIGATION_BAR.CREATE", fallback: "Create")
    }
  }
  public enum Generic {
    /// Delete
    public static let delete = Strings.tr("Localizable", "GENERIC.DELETE", fallback: "Delete")
    /// Done
    public static let done = Strings.tr("Localizable", "GENERIC.DONE", fallback: "Done")
    /// Edit
    public static let edit = Strings.tr("Localizable", "GENERIC.EDIT", fallback: "Edit")
    /// Ok
    public static let okay = Strings.tr("Localizable", "GENERIC.OKAY", fallback: "Ok")
    /// Save
    public static let save = Strings.tr("Localizable", "GENERIC.SAVE", fallback: "Save")
  }
  public enum History {
    /// Date
    public static let axisLabelDate = Strings.tr("Localizable", "HISTORY.AXIS_LABEL_DATE", fallback: "Date")
    /// Graph Content
    public static let graphContent = Strings.tr("Localizable", "HISTORY.GRAPH_CONTENT", fallback: "Graph Content")
    /// History
    public static let navigationTitle = Strings.tr("Localizable", "HISTORY.NAVIGATION_TITLE", fallback: "History")
    /// No data to display
    public static let noDataToShow = Strings.tr("Localizable", "HISTORY.NO_DATA_TO_SHOW", fallback: "No data to display")
    public enum GraphType {
      /// Income
      public static let income = Strings.tr("Localizable", "HISTORY.GRAPH_TYPE.INCOME", fallback: "Income")
      /// Time
      public static let time = Strings.tr("Localizable", "HISTORY.GRAPH_TYPE.TIME", fallback: "Time")
    }
  }
  public enum List {
    /// Sheet
    public static let navigationTitle = Strings.tr("Localizable", "LIST.NAVIGATION_TITLE", fallback: "Sheet")
    public enum Footer {
      /// Total
      public static let total = Strings.tr("Localizable", "LIST.FOOTER.TOTAL", fallback: "Total")
    }
    public enum NavigationBar {
      /// Generate
      public static let generate = Strings.tr("Localizable", "LIST.NAVIGATION_BAR.GENERATE", fallback: "Generate")
      /// Payout
      public static let payout = Strings.tr("Localizable", "LIST.NAVIGATION_BAR.PAYOUT", fallback: "Payout")
    }
  }
  public enum Payouts {
    /// Payout
    public static let activityText = Strings.tr("Localizable", "PAYOUTS.ACTIVITY_TEXT", fallback: "Payout")
    /// Payouts
    public static let navigationTitle = Strings.tr("Localizable", "PAYOUTS.NAVIGATION_TITLE", fallback: "Payouts")
    public enum SwipeActions {
      /// Edit Payout
      public static let edit = Strings.tr("Localizable", "PAYOUTS.SWIPE_ACTIONS.EDIT", fallback: "Edit Payout")
    }
  }
  public enum Settings {
    /// Currency
    public static let currency = Strings.tr("Localizable", "SETTINGS.CURRENCY", fallback: "Currency")
    /// Hourly wage
    public static let hourlyWage = Strings.tr("Localizable", "SETTINGS.HOURLY_WAGE", fallback: "Hourly wage")
    /// Settings
    public static let navigationTitle = Strings.tr("Localizable", "SETTINGS.NAVIGATION_TITLE", fallback: "Settings")
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