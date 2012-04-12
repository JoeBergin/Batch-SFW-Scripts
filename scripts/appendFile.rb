#!/usr/bin/ruby
require 'rubygems'
require 'json'

def page title, json
  File.open("#{@destination}/#{slug(title)}", 'w') do |file| 
    file.write JSON.pretty_generate(json)
  end
end

def slug title
  title.gsub(/\s/, '-').gsub(/[^A-Za-z0-9-]/, '').downcase()
end

def appendFile base, merge
	begin
		baseJson = JSON.parse(base)
		mergeJson = JSON.parse(merge)
		# merge the stories
		lastId = baseJson['story'][baseJson['story'].length - 1]['id']
		baseJson['story'] = baseJson['story'] + mergeJson['story']
		# update the journal
		mergeJson['story'].each do |para|
			entry = { 
				'after' => lastId,
				'id' => para['id'],
				'type' => "add",
				"item" => {
						'id' => para['id'],
						'type' => para['type']
						}
				}
			lastId = para['id']
			baseJson['journal'] << entry
		end
		# write the new file 
		page baseJson['title'], baseJson
	rescue
		puts 'Parse error.'
	end
end


##############

@base = ''
@merge = ''
@directory = 'originals'
@destination = '../changes'

if ARGV.length == 2
	@base = ARGV[0]
	@merge = ARGV[1]
else
	puts 'usage: aappendFile baseFile mergeFile'
	exit
end

begin
	filename = slug @base
	#puts filename
	doc = IO.read("#{@directory}/#{filename}" )
rescue
	puts 'No Page with Title: ' + @base
	exit
end
begin
	filename = slug @merge
	#puts filename
	mergee = IO.read("#{@directory}/#{filename}" )
rescue
	puts 'No Page with Title: ' + @merge
	exit
end
appendFile doc, mergee
