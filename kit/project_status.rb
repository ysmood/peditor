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
	ret = true
	exclude.each { |extension|
		if f.end_with?(extension)
			ret = false
			break
		end
	}
}

report = {}

sum = files.reduce(0) { |sum, f|
	count = `wc -l #{f}`.split.first.to_i
	report[f] = count
	sum + count
}

report = report.sort_by { |k, v| -v }

report.each { |k, v|
	puts ('%6d   ' % v) + k
}

puts "\nTotal: " + sum.to_s
