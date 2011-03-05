rapidui is a collection of tools for rapid prototyping and designing directly in the browser. 

It consists of a HTML&CSS framework for managing layouts and a number of utility JavaScript and Ruby scripts.      

#The Grid     
#Scripts           
##typography.rb           
##css_manager.rb           

more to follow  The Grid  A small HTML&CSS framework designed around the following principles:     1. Both fixed and flexible layouts must be possible    2. Flexible layouts must utilize responsive web design    3. Flexible layouts must be infinitely nestable    4. There must be extreme separation of concern between CSS declarations    5. Layouts of any complexity should be achieved using the least amount of markup and CSS possible.  Grid dimensions  The grid is built on a screen width of 1080 pixels divided by 12 columns; thus the basic unit of the grid is a column 70 pixels wide with a 10px gutter on each side (left and right margins), giving 70+2*10=90. (1080 is divisible by 2, 3, 4, 5, 6, 8, 10, 12, and 15. I've chosen 12 columns as this is the most common integer division for CSS grid systems).  Subsequent divisions (2 columns, 3 columns, and all the way to 12 columns) are calculated using the formula 70*n+20*(n-1), where n is the number of columns. For example, a five-column wide block is 70*5+20*4=430px. This is because a block of n units has the width of the basic column (70px) repeated n times, plus the widths of the spaces in between the columns. When 2 columns are adjacent to each other, the space between them is 20px, as each column contributes with 10px on each side. A five-column cell has five 70px units with 4 adjacent spaces in between the units; therefore, 70*5+20*4=430px. 