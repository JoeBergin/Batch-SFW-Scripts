#!/usr/bin/ruby
require 'rubygems'
require 'json'

def random
  (1..16).collect {(rand*16).floor.to_s(16)}.join ''
end

def paragraph text
  {'type' => 'paragraph', 'text' => text, 'id' => random()}
end

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
		if @notify
			newPara = paragraph "Following merged from: " + mergeJson['title']
			baseJson['story'] = (baseJson['story'] << newPara) + mergeJson['story']
		else
			baseJson['story'] = baseJson['story']  + mergeJson['story']
		end
		# update the journal
		if @notify
			baseJson['journal'] << {
				'type' => 'add',
				'id' => newPara['id'],
				'item' => newPara
			}
		end
		mergeJson['story'].each do |para|
			entry = { 
				'after' => lastId,
				'id' => para['id'],
				'type' => "add",
				"item" => para
					#	{
					#	'id' => para['id'],
					#	'type' => para['type']
					#	}
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
@notify = false

if ARGV.length == 2
	@base = ARGV[0]
	@merge = ARGV[1]
elsif ARGV.length == 3
	if ARGV[0] == '-n'
		@notify = true
	end
	@base = ARGV[1]
	@merge = ARGV[2]
else
	puts 'usage: ./appendFile.rb [-n] baseFile mergeFile'
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
