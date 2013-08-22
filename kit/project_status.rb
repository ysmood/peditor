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

sum = files.reduce(0) { |s, f|
	# Count how many lines of code a file has.
	c = `wc -l #{f}`.split.first.to_i

	report[f] = c

	s + c
}

report = report.sort_by { |k, v| -v }

report.each { |k, v|
	puts '%6d   %s' % [v, k]
}

puts "\nTotal: " + sum.to_s
