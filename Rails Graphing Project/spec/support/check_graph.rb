module CheckGraph
  module Ticks
    extend ::RSpec::Matchers
    def self.hour(ticks)
      yesterday = DateTime.now - 1.days
      regex = /(00:00|03:00|06:00|09:00|12:00|15:00|18:00|21:00)#{yesterday.strftime('%b %d').upcase}/
      expect(ticks[0].text.match(regex).to_s).to eq(ticks[0].text)

      regex = /(00:00TODAY|03:00|06:00|09:00|12:00|15:00|18:00|21:00)/
      ticks.each do |tick|
        next if tick == ticks.first

        expect(tick.text.match(regex).to_s).to eq tick.text
      end
    end

    def self.day(ticks)
      regex = /(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC) [0-3]\d/
      ticks.each do |tick|
        expect(tick.text.match(regex).to_s).to eq tick.text
      end
    end

    def self.day_through_year(ticks)
      regex = /(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC) [0-3]\d\d\d\d\d/
      expect(ticks[0].text.match(regex).to_s).to eq ticks[0].text
      regex = /((JAN 0\d\d{0,4})|((JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC) [0-3]\d))/
      ticks.each do |tick|
        next if tick == ticks.first

        expect(tick.text.match(regex).to_s).to eq tick.text
      end
    end

    def self.month(ticks)
      regex = /(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\d\d\d\d/
      expect(ticks[0].text.match(regex).to_s).to eq ticks[0].text

      regex = /(JAN\d\d\d\d|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)/
      ticks.each do |tick|
        next if tick == ticks.first

        expect(tick.text.match(regex).to_s).to eq tick.text
      end
    end

    def self.year(ticks)
      regex = /\d\d\d\d/
      ticks.each do |tick|
        expect(tick.text.match(regex).to_s).to eq tick.text
      end
    end

    def self.bp_measurements(ticks)
      regex = /\d{1,3}/
      ticks.each do |tick|
        expect(tick.text.match(regex).to_s).to eq(tick.text)
      end
    end

    def self.medication(ticks)
      ticks.each do |tick|
        expect(tick.text).not_to be_empty
      end
    end
  end

  module Bars
    def self.get_position(translate)
      position = translate.split(/translate\(|,|\)/)
      {
        x: position[1].to_f,
        y: position[2].to_f
      }
    end
  end
end
