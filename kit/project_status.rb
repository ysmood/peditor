#!/usr/bin/env ruby

# A tool to detect the project's code status.

files = `git ls-files`.split

exclude = [
  '.png',
  '.gif',
  '.ico',
  '.jpg',
  '.ttf',
]

files = files.select { |f|
  exclude.each { |extension|
    if f.end_with?(extension)
      break
    end
  }
}

report = {}

sum_count = files.reduce(0) { |sum, f|
  count = `wc -l #{f}`.split.first.to_i
  report[f] = count
  sum + count
}

report = report.sort_by { |k, v| -v }

report.each { |k, v|
  puts "%6d   %s" % [v, k]
}

puts "\nTotal: " + sum_count.to_s
