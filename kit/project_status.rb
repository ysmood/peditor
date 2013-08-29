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
	ret
}

report = {}

line_sum = 0
size_sum = 0

files.each { |f|
	# Count how many lines of code a file has.
	l = `wc -l #{f}`.split.first.to_i

	# File size.
	s = File.size(f) / 1024.0

	report[f] = l

	line_sum += l
	size_sum += s
}

report = report.sort_by { |k, v| -v }

report.each { |k, v|
	puts '%6d   %s' % [v, k]
}

puts "\nTotal lines: %d" % line_sum
puts " Total size: %.2f KB" % size_sum
