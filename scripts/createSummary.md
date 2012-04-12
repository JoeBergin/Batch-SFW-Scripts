<p> The script createSummary.rb creates an index page for a site. If run with no command line arguments, it reads all of the filnames from originals and writes a single file, index-of-pages, into the pages folder that is an index to all of the pages in the set. It contains one paragraph for each file, with the name of the page in a link. </p>

<p> createSummary has three possible command line paramenters. If -s is used, the next argument is a string containing the path to the source directory. If -d is used, the next argument is a string with the path to the destination. If -t is used, the next argument is a string with the title of the index page itself. </p>

<p> The following produces the same thing as the defaults. </p>

<p> /usr/bin/ruby ./createSummary.rb -d '../pages' -t 'Index Of Pages' -s './originals' </p>

<p>It will also index the welcome-visitors page, which may not behave as you like. In which case, just remove that paragraph from the result.</p>
