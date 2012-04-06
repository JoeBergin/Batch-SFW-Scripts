require 'rubygems'
require 'json'

def page title, json
  page = json 
  File.open("#{@destination}/#{slug(title)}", 'w') do |file| 
    file.write JSON.pretty_generate(page)
    #file.close
  end
end

def slug title
  title.gsub(/\s/, '-').gsub(/[^A-Za-z0-9-]/, '').downcase()
end

@changed  = []

def handleOneFile filename, oldName, newName
	begin
		changed = false
		doc = IO.read(filename)
		json = JSON.parse(doc)
		paragraphs = json['story']
		paragraphs.each do |para|
			if para['type'] == 'paragraph' or para['type'] == 'image'
				theText = para["text"]
				newText = theText.gsub("[[#{oldName}]]", "[[#{newName}]]")
				if theText != newText
					para['text'] = newText
					changed = true
					@changed << filename
				end
			end
		end
		if changed
			page json["title"], json
		end	
	rescue
		puts filename + ' has issues'
		nil
	end
end

def renameFileSet  oldName, newName
	begin
		Dir.glob("#{@directory}/*").each do |filename|
#			puts filename
			handleOneFile filename, oldName, newName			
		end
	rescue
		puts 'ignored'
	end
end

def grabTitleFile newTitle, doc
# gets the official name of the page and also updates its file
	begin
		json = JSON.parse(doc)
		#check it isn't a fork
		oldJournal = json['journal'] # an array of journal entries
		oldJournal.each do |entry|
			if entry['type'] == 'fork'
				puts "Page is a fork. Exiting."
				exit
			end
		end
		
		result = json['title']
		json['title'] = newTitle
		page newTitle, json
		handleOneFile "#{@destination}/#{slug(newTitle)}", @original, @newName
		result
	rescue
		puts 'No page with this title.'
		nil
	end
end

def summary
	if @changed.length > 0
		puts 'Changes in files:'
		@changed.each{|r| p r}
	else
		puts 'Found in no files'
	end
end


@original = ''
@newName = ''
@directory = 'originals'
@destination = '../changes'

if ARGV.length == 2
	@original = ARGV[0]
	@newName = ARGV[1]
else
	puts 'usage: renamePage originalName newName'
	exit
end

begin
	filename = slug @original
	#puts filename
	doc = IO.read("#{@directory}/#{filename}" )
	@original = grabTitleFile @newName, doc
	renameFileSet @original, @newName
rescue
	puts 'No Page with Title: ' + @original
end
summary

