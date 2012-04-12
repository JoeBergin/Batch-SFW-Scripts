<p>Docs for appendFile.rb</p>

<p>This script will merge one JSON file into another by appending one to the other. The originals are not altered, but a new file is written containing the merged files. </p>

<p>One file is the base. It will appear first in the result. The other is the merge. It will be appended to the base. The new file will have the same title and filename as the base. </p>

<p>The two input files must be in ./originals. The result is written to ../changes</p>

<p>Usage, assuming appendFile has been made executable:</p>

<p>cd to the scripts directory <br/>
./appendFile.rb base merge</p>

<p>In addition, for each paragraph added to the result (from the merge file) a new journal entry is added to the result indicating that a paragraph (or other item) was added. </p>
