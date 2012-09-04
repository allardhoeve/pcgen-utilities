Bestiary Sheet Creator for summoners
====================================

1. Put the creatures you want on your sheet in a tab-delimited textfile.
   1. First column is the URL to dxcontent.com, e.g. "http://www.dxcontent.com/MDB_MonsterBlock.asp?MDBID=70"
   1. Second column is a description, like "Devil, Bearded", but it's only used in debugging.
1. Run the script like so:

   ```bash
   ./aggregate-dxcontent-bestiary-entries.pl < devils.txt > summoning-devils.html
   ```

1. Open in a browser. Press ctrl-p. Print.
