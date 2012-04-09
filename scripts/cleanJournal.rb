#!/usr/bin/ruby
require 'rubygems'
require 'json'

def page title, json
  page = json 
  File.open("../pages/#{title}", 'w') do |file| 
    file.write JSON.pretty_generate(page)
    #file.close
  end
end

# This version leaves any history with a fork intact
# A previous version deleted everthing after the first
# fork (if any). That was considered undesirable, but
# the code for this was left here as comments. This also
# explains why it (unnecessarily) counts to the first fork. 

def clean  title, doc
	begin
		json = JSON.parse(doc)
	#	puts json['journal'][0]['type']
		oldJournal = json['journal'] # an array of journal entries
		noForks = true
#		index = 0
		oldJournal.each do |entry|
			if entry['type'] == 'fork'
				noForks = false
#				index += 1
				break
			end
#			index = index + 1
		end
		if noForks
			journal = [oldJournal[0]]
		else
			journal = oldJournal #oldJournal[0, index]
		end	
		json['journal'] = journal
		page title, json
	rescue
		puts 'ignored'
		nil
	end
end

Dir.glob('originals/*').each do |filename|
#	puts filename
    doc = IO.read(filename)
	filename = filename.gsub(/originals\//,'')
	puts filename
    clean filename, doc
end

