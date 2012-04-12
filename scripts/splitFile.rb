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

def numberOfWords title
	ct = 0
	title.each_byte do |c|
		ct +=1 if c.chr.downcase != c.chr
	end
	return ct
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
				name = text.match(/<\s*[Ss][Pp][Ll][Ii][Tt]\s*>(.*?)<\s*\/[Ss][Pp][Ll][Ii][Tt]\s*>/)
				name = name[1] unless name == nil	
				if name != nil
					json['story'] = newStory
					json['title'] = currentTitle
					page currentTitle, json
					newStory = []
					currentTitle = name.strip
					if numberOfWords(currentTitle) <= 1
						warn '"' + currentTitle + '"' + " is a single word or has missing uppercase letters. Consider good multi-word titles."
					end
				else
					newStory << para 
				end
			end
		end
		json['title'] = currentTitle
		json['story'] = newStory
		page currentTitle, json
	rescue
		puts 'Parse error.'
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
	splitFile doc 
rescue
	puts 'No file with name: ' + @original
end
