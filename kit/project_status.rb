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

sum = files.reduce(0) { |sum, f|
	count = `wc -l #{f}`.split.first.to_i
	puts ('%6d   ' % count) + f 
	sum + count
}

puts "\nTotal: " + sum.to_s
