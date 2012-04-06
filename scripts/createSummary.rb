require 'rubygems'
require 'json'

def random
  (1..16).collect {(rand*16).floor.to_s(16)}.join ''
end

def slug title
  title.gsub(/\s/, '-').gsub(/[^A-Za-z0-9-]/, '').downcase()
end

def create title
  {'type' => 'create', 'id' => random, 'item' => {'title' => title}}
end 

def paragraph text
  {'type' => 'paragraph', 'text' => text, 'id' => random()}
end

@summary = []

def page title, story
	page = {'title' => title, 'story' => story, 'journal' => [create(title)]}
  	File.open("#{@dest}/#{slug(title)}", 'w') do |file| 
		file.write JSON.pretty_generate(page)
	end
end

def grabTitle doc
	begin
		json = JSON.parse(doc)
		title = json['title']
		@summary << paragraph("[[#{title}]]")
	rescue
		puts 'ignored'
		nil
	end
end

def summarize
	page @title, @summary
end

@source = 'originals'
@dest = '../pages/'
@title = 'Index Of Pages'

for i in 0...ARGV.length 
	if ARGV[i] == '-s'
		@source = ARGV[i+1]
	elsif ARGV[i] == '-d'
		@dest = ARGV[i+1]
	elsif ARGV[i] == '-t'
		@title = ARGV[i+1]
	end
end

Dir.glob(@source + '/*').each do |filename|
	puts filename
	doc = IO.read(filename)
	grabTitle doc
end

summarize