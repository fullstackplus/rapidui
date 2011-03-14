#rapidui

&hellip;is a collection of tools for rapid prototyping and designing directly in the browser.

It consists of a HTML&CSS framework for managing layouts and a number of utility JavaScript and Ruby scripts.      

<ul>
    <li><a href="#grid">The Grid</a></li>
    <li>Scripts
        <ul>
            <li>typography.rb</li>
            <li>css_manager.rb</li>
            <li>more to follow</li>
        </ul>
    </li>
</ul>

<h2><a name="grid">The Grid</a></h2>
A small HTML&CSS framework designed around the following principles:

1. Both fixed and flexible layouts must be possible
2. Flexible layouts must utilize responsive web design
3. Flexible layouts must be infinitely nestable
4. There must be extreme separation of concern between CSS declarations
5. Layouts of any complexity should be achieved using the least amount of markup and CSS possible.

###Grid dimensions
The grid is built on a screen width of 1080 pixels divided by 12 columns;
thus the basic unit of the grid is a column 70 pixels wide with a 10px gutter on each side
(left and right margins), giving 70+2\*10=90. (1080 is divisible by 2, 3, 4, 5, 6, 8, 10, 12,
and 15. I've chosen 12 columns as this is the most common integer division for CSS grid systems).

Subsequent divisions (2 columns, 3 columns, and all the way to 12 columns) are calculated
using the formula 70\*n+20\*(n-1), where n is the number of columns. For example, a five-column
wide block is 70\*5+20\*4=430px. This is because a block of n units has the width of the basic
column (70px) repeated n times, plus the widths of the spaces in between the columns. When 2
columns are adjacent to each other, the space between them is 20px, as each column contributes
with 10px on each side. A five-column cell has five 70px units with 4 adjacent spaces in between
the units; therefore, 70\*5+20\*4=430px.

###Classes

The grid relies on the following classes:

<ol>
    <li>
        <pre>.rowContainer</pre>
        Achieves horizontal breaks and vertical rhythm between layout elements;
        groups together cells in the grid. This is the "row" element.
    </li>
    <li>
        <pre>.[1-12]Col</pre>
        The 12 column elements corresponding to the 12-column division, with the addition of
        <pre>.wideCol</pre> and <pre>.narrowCol</pre>, corresponding to the wide and narrow
        divisions of the Golden Section, respectively.
    </li>
    <li>
        <pre>.group</pre>
        For containing floats. I'm using Tony Aslett's clearfix method here; see
[How To Clear Floats Without Structural Markup](http://www.positioniseverything.net/easyclearing.html "Article on the clearfix method")
    </li>
    <li>
        <pre>.wrapper</pre>
        For centering layout elements. This element is what is commonly referred to as the "container". In rapidui,
    </li>
</ol>

###The main hack

The grid system uses a CSS3 substring matching attribute selector to achieve grouping of cells:
<pre>.rowContainer>*[class$="Col"]</pre>
This means that any element with the class attribute ending with "Col" will be treated as a cell
in the grid. The actual dimensions of the cell element is declared for each individual element,
ie a class tagged with RC only takes care of the floating and margins.

Together, an element tagged with RC and a number of *Col elements constitute what is known in Object-Oriented
CSS terminology an "object":

<pre>
    <div class="rowContainer">
        <div class=sixCol></div>
        <div class=sixCol></div>
    </div>
</pre>

An object is an element with a parent element
