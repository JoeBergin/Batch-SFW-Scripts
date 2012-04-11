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

def splitFile doc
# gets the official name of the page and also splits it
	begin
		json = JSON.parse(doc)
		#check it isn't a fork
		journal = json['journal'] # an array of journal entries		
		currentTitle = json['title']
		story = json['story']
		newStory = []
		story.each do |para|
			if  para['type'] != "paragraph"
				newStory << para
			else
				text = para['text']
				name = text.match(/<\s*split\s*>(.*?)<\s*\/split\s*>/)
				name = name[1] unless name == nil	
				if name != nil
					json['story'] = newStory
					json['title'] = currentTitle
					page currentTitle, json
					newStory = []
					currentTitle = name.strip
				else
					newStory << para 
				end
			end
		end
		json['title'] = currentTitle
		json['story'] = newStory
		page currentTitle, json
	rescue
		puts 'No page with this title.'
	end
end


def warn s
	puts "#######  " + s
end

#######

@original = ''
@directory = 'originals'
@destination = '../changes'

if ARGV.length == 1
	@original = ARGV[0]
else
	puts 'usage: splitFile.rb originalName'
	exit
end

begin
	filename = slug @original
	doc = IO.read("#{@directory}/#{filename}" )
	splitFile doc #, @original
rescue
	puts 'No Page with Title: ' + @original
end
