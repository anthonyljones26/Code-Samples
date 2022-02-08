module ResultsGraphingFhir
  module TooltipHelper
    TOOLTIP_LABELS = %w[
      Start\ Date
      End\ Date
      Quantity
      Frequency
      Compliance
      Category
      Additional\ Instructions
    ].freeze

    TOOLTIP_HEADER = %w[
      Name
      Strength
    ].freeze

    def check_tooltip(actual, expected)
      actual.each_with_index do |el, index|
        expect(el).to have_text(expected[index])
      end
    end

    def check_header(values, labels = TOOLTIP_HEADER)
      within('.tooltip-header') do
        check_tooltip(find_all('.tooltip-label'), labels)
        check_tooltip(find_all('.tooltip-value'), values)
      end
    end

    def check_entry(values, labels = TOOLTIP_LABELS)
      within('.tooltip-entry:nth-of-type(1)') do
        check_tooltip find_all('.tooltip-label'), labels
        check_tooltip find_all('.tooltip-value'), values
      end
    end
  end
end
