<p>Docs for splitFile.rb</p>

<p>splitFile will split one json file into parts. The original must be in the originals directory (./originals) and the results will be put into ../changes.</p>

<p>The journal of the original is preserved in all of the parts. </p>

<p>The original file is not modified. However a new file with the same name and Title will be created in the changes directory. </p>

<p>It works like this. Suppose you want to split page My Master (filename my-master) into three parts. The first part will have the name My Master. You can choose the names for the split-off parts. </p>

<p>Somewhere in the file put the following. It should be in a paragraph by itself since the paragraph that contains it is lost in translation. </p>

<p><split>Part One</split></p>

<p>and later, another paragraph containing</p>

<p><split>Part Two</split> </p>

<p>(It requires the tag names in lower case now)</p>

<p>You will then get three files: my-master, part-one, and part-two, with the three pages. The first file contains every paragraph up to (not including) the paragraph containing the first split "tag". The second file everything in paragraphs between the two splits (but not the paragraphs with the tags) and the third file contains every paragraph past the paragraph with the second split.</p>

<p>It does not modify any paragraph, but loses the ones with the split tags. It does not modify the journal, but copies it into each created page. </p>

<p>Run it like this (assuming you've made it executable:</p>

<p>cd to the scripts directory:
./splitFile 'name of the source'</p>

<p>The name of the source can be either a filename (of a file in the originals directory) or a page title. Either works. Do not include the path to originals. </p>

<p>For example, both work:</p>

<p>Silver:scripts jbergin$ ./splitFile.rb "table-trial"
Silver:scripts jbergin$ ./splitFile.rb "Table Trial"</p>