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

def numberOfWords title
	ct = 0
	title.each_byte do |c|
		ct +=1 if c.chr.downcase != c.chr
	end
	return ct
end

@toRemove = [[],[]]

# paragraph ids to remove from each journal
def markRemove id, which
	0.upto(@toRemove.length - 1) { |i|
		if i != which
			@toRemove[i] << id
		end
	}
end

# to record the splitter paragraphs
def recordInAll id
	0.upto(@toRemove.length - 1) { |i|
			@toRemove[i] << id
	}
end

def splitFile doc
# gets the official name of the page and also splits file at splitter paragraphs
	begin
		json = JSON.parse(doc)
		journal = json['journal'] # an array of journal entries		
		originalTitle = currentTitle = json['title']
		story = json['story']
		newStory = []
		journalAnnounce = [nil]
		pages = [] # will save generated  pages until the end
		whichPart = 0
		story.each do |para|
			if  para['type'] != "paragraph"
				newStory << para
				markRemove para['id'], whichPart
			else
				text = para['text']
				name = text.match(/<\s*[Ss][Pp][Ll][Ii][Tt]\s*>(.*?)<\s*\/[Ss][Pp][Ll][Ii][Tt]\s*>/)
				name = name[1] unless name == nil	
				if name != nil # in a splitter paragraph
					recordInAll para['id'] # removing the splitter para
					json['story'] = newStory
					json['title'] = currentTitle
					json['journal'] = journal.clone
=begin
					if whichPart > 0 # first part isn't a fork
						json['journal'] << {
							'type' => 'fork',
							'site' => originalTitle  # what should this be??
						}
					end
=end
					pages << json.clone # save the page
					whichPart += 1
					# everything removed so far is also removed from next part
					@toRemove << @toRemove[@toRemove.length - 1].clone
					if @notify
						splitAnnounce = paragraph 'Split from: ' + originalTitle
						newStory = [splitAnnounce]
						journalAnnounce << {"type" => 'add', 'id' => splitAnnounce['id'], 'item' => splitAnnounce}
					else
						newStory = []
					end
					currentTitle = name.strip
					if numberOfWords(currentTitle) <= 1
						warn '"' + currentTitle + '"' + " is a single word or has missing uppercase letters. Consider good multi-word titles."
					end
				else
					newStory << para 
					markRemove para['id'], whichPart
				end
			end
		end
		json['title'] = currentTitle
		json['story'] = newStory
		json['journal'] = journal.clone
=begin
		if whichPart > 0
			json['journal'] << {
				'type' => 'fork',
				'site' => originalTitle  # what should this be??
			}
		end
=end
		pages << json.clone # save the page
		count = 0
# add the journal 'add' entry here -- but which entry
		# record the removals in the journals and output the pages
		pages.each do |onePage|
			if @notify
				onePage['journal'] << journalAnnounce[count] unless count == 0
			end
			@toRemove[count].each do |id|
				onePage['journal'] << {
					'type' => 'remove',
					'id' => id
				}
			end
			page onePage['title'], onePage
			count += 1
		end
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
@notify = false

if ARGV.length == 1
	@original = ARGV[0]
elsif ARGV.length == 2
	if ARGV[0] == '-n'
		@notify = true
	end
	@original = ARGV[1]
else
	puts 'usage: splitFile.rb  [-n] originalName'
	exit
end

begin
	filename = slug @original
	doc = IO.read("#{@directory}/#{filename}" )
	splitFile doc 
rescue
	puts 'No file with name: ' + @original
end
