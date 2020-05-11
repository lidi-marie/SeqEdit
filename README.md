# Lidis-SeqEdit
Nucleic acid fast and easy everyday sequence editor.

This is a nucleic acid sequence editor shinyapp.ios made in R. 

Link to webapp: https://lidi.shinyapps.io/Lidi-SeqEdit/
Since I'm currently in a free-version of shiny the web application only has 25 active hours per month. Sorry! 

Lidis-SeqEdit currenlty has the following **outputs**:

# Quick facts 
Gives a quick view of:
```
--Sequence length : Length of sequence, not including spaces and line breaks
--GC% : Percentage of G and C instances in sequence (rounded to 2 decimals). 
--dsDNA: Molecular Weigth (g/mol) for double stranded DNA, in scientific notation. 
--ssDNA: Molecular Weigth (g/mol) for single stranded DNA, in scientific notation. 
--ssDNA: Molecular Weigth (g/mol) for single stranded RNA, in scientific notation. 
*Note the sequencer does not diferentiatie between DNA/RNA, and accepts all alphabet letters. 
```


# Editor Output 
Output Window for select transformations:
```
--None: No change is made to sequence. 
--Reverse: Sequence is reverse (i.e. AGT --> TGA) 
--Complement: Sequence is complemented acoring to DNA/RNA base pairing (i.e. A->T, C->G, T->A, G->C), all other characters are ignored. 
--Reverse Complement: Sequence is complemented and reversed (i.e. ATG --> CAT) 
*Note all U are complemented to A. 
```
All output transformations only transform the input box, it does not stack transformations.


💧


# Make an app shortcut 

How to make a shortcut that will open in a browser. 

1. Copy and paste in TextEdit, make sure file extension is .command: 

```
  Rscript '/Users/PATH/Lidi-SeqEdit.R' & open http://127.0.0.1:7658/;
``` 
Remember to change PATH for yours. 

2. At the end of Lidi-SeqEdit.R make sure the last line looks like:
 
 ```
 shinyApp(ui=ui,server=server,options = list(port=7658))
 ```
 The port number must match the address set in the .command file. 

3. Make sure the .command has execute permission.

4. Add a file icon, and you're set! Double click to launch app. 







