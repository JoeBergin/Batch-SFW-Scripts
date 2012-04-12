<html><body>

<p>Docs for the cleanJournal.rb script. </p>

<p>The script cleanJournal.rb will process a batch of SFW pages and will remove most of the journal. It is useful in a few situations, but probably not generally. </p>

<p>I created it because I used SFW to write an extended essay on one server for eventual publication on another, using a batch transfer mechanism. The journal was quite long, as the essay was written incrementally. I wanted to publish with a minimal journal. </p>

<p>The script will leave at least the first entry of the journal, usually create (C), and it will leave unchanged any history that contains a fork (F). So if you got the page by forking from another server, it preserves the history.</p>

<p>To use this, you need to put COPIES of the set of files from the pages directory of the server on which they were created into the originals directory here (scripts/originals). Then, from the scripts directory (cd...scripts) run the script with something like ruby ./cleanJournal.rb. The program has no options. </p

<p> Files that json won't parse are ignored. </p>

<p>The originals will not be modified, but the new pages will be in the pages directory here (../pages). These new pages can be moved back into the server area. Everything should be preserved except parts of the journal, but use at your own risk, and make sure you aren't copying over important information. Backups are your friend, as ususal. </p>

</body></html>