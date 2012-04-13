<body><html>

<p>Docs for splitFile.rb</p>

<p>splitFile will split one json file into parts. The original must be in the originals directory (./originals) and the results will be put into ../changes.</p>

<p>The journal of the original is preserved in all of the parts, with updates for paragraphs "removed" from each part. </p>

<p>The original file is not modified. However a new file with the same name and Title will be created in the changes directory. </p>

<p>It works like this. Suppose you want to split page My Master (filename my-master) into three parts. The first part will have the name My Master. You can choose the names for the split-off parts. </p>

<p>Somewhere in the file put the following. It should be in a paragraph by itself since the paragraph that contains it is lost in translation. </p>

<p>&lt;split>Part One&lt;/split></p>

<p>and later, another paragraph containing</p>

<p>&lt;split>Part Two&lt;/split> </p>

<p>(It requires the tag names in lower case now - FIXED)</p>

<p>You will then get three files: my-master, part-one, and part-two, with the three pages. The first file contains every paragraph up to (not including) the paragraph containing the first split "tag". The second file everything in paragraphs between the two splits (but not the paragraphs with the tags) and the third file contains every paragraph past the paragraph with the second split.</p>

<p>You are encouraged to use good names, nowever. They should be multi-word, intention revealing names that will work well across a federation of wikis. 

<p>It does not modify any paragraph, but loses the ones with the split tags. It updates the journal for each created file. First, it copies the original into each created page and then includes a remove entry for each paragraph that doesn't appear in this file. </p>

<p>The "split paragraphs" were recorded in the journals when added, and the remove is also recorded.</p>

<p>Run it like this (assuming you've made it executable:</p>

<p>cd to the scripts directory:<br/>
./splitFile 'name of the source'</p>

<p>The name of the source can be either a filename (of a file in the originals directory) or a page title. Either works. Do not include the path to originals. </p>

<p>For example, both of these work:</p>

<p>Silver:scripts jbergin$ ./splitFile.rb "table-trial" <br/>
Silver:scripts jbergin$ ./splitFile.rb "Table Trial"</p>

</body></html>
