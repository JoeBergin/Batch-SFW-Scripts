<p> There are three scripts here.</p>

<p> The files in scripts/originals are not important. They are just for testing.</p>

<p>The script cleanJournal.rb will process a batch of SFW pages and will remove most of the journal. It is useful in a few situations, but probably not generally. </p>

<p>I created it because I used SFW to write an extended essay on one server for eventual publication on another, using a batch transfer mechanism. The journal was quite long, as the essay was written incrementally. I wanted to publish with a minimal journal. </p>

<p>The script will leave at least the first entry of the journal, usually create (C), and it will leave unchanged any history that contains a fork (F). So if you got the page by forking from another server, it preserves the history.</p>

<p>To use this, you need to put COPIES of the set of files from the pages directory of the server on which they were created into the originals directory here (scripts/originals). Then, from the scripts directory (cd...scripts) run the script with something like ruby ./cleanJournal.rb </p

<p> Files that json won't parse are ignored. </p>

<p>The originals will not be modified, but the new pages will be in the pages directory here. These new pages can be moved back into the server area. Everything should be preserved except parts of the journal, but use at your own risk, and make sure you aren't copying over important information. Backups are your friend, as ususal. </p>

<p> The script createSummary.rb creates an index page for a site. If run with no command line arguments, it reads all of the filnames from originals and writes a single file, index-of-pages, into the pages folder that is an index to all of the pages in the set. It contains one paragraph for each file, with the name of the page in a link. </p>

<p> createSummary has three possible command line paramenters. If -s is used, the next argument is a string containing the path to the source directory. If -d is used, the next argument is a string with the path to the destination. If -t is used, the next argument is a string with the title of the index page itself. </p>

<p> The following produces the same thing as the defaults. </p>

<p> /usr/bin/ruby ./createSummary.rb -d '../pages' -t 'Index Of Pages' -s './originals' </p>

<p>It will also index the welcome-visitors page, which may not behave as you like. In which case, just remove that paragraph from the result.</p>


<p>A third script, renamePage.rb, is intended to be used to change the name of a page and all references to it on the local server. It will read the originals directory and write to a new ../changed directory any files that are modified. Usage is ruby ./renamePage originalName newName. </p>

<p>The page with that original name, if any, has its title changed, and any file that references this page will have all references updated to point to the new page. No other changes are made. In particular, only references are updated, not identical text in other places. The journal is not affected, so that the old references remain in the journal and even in the name of the page changed. Furthermore, it processes only 'paragraph'  and 'image' elements of the story. It looks at image captions, which can contain links. </p>

<p> However, if the page to be changed has any fork elments in its history, the name is not changed, nor is any other page changed.</p>

<p> It is likely the case that a page once forked to another site should not have its name changed. But this does not do that. I think this area needs more thought than this script provides.</b>
