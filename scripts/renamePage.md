<html><body>

<p>Docs for renamePage.rb</p>


<p>The script, renamePage.rb, is intended to be used to change the name of a page and all references to it for the local server. It will read the originals directory (./originals) and write to a new ../changed directory any files that are modified. </p>

<p>Usage is: </p>

<p>path/to/ruby ./renamePage.rb originalName newName. </p>

<p>The page with that original name, if any, has its title changed, and any file in ./originals that references this page will have all references updated to point to the new page. No other changes are made. In particular, only references are updated, not identical text in other places. The journal is not affected, so that the old references remain in the journal and even in the name of the page changed. Furthermore, it processes only 'paragraph'  and 'image' elements of the story. It looks at image captions, which can contain links. </p>

<p>The script also writes a page with the original name and a forwarding link to the new page</p>

<p> However, if the page to be changed has any fork elments in its history, the name is not changed, nor is any other page changed.</p>

<p> It is likely the case that a page once forked to another site should not have its name changed. But this does not do that. I think this area needs more thought than this script provides.</b>

</body></html>