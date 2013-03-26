*UPDATE 26.03.2013:*

I am no longer maintaining rapidui, but am using responsive grid systems on a per-project
basis. The approach I'm currently pursuing is a column-by-column adaptive approach described
[in this essay](http://jamesabbottdd.com/design/lessons-learned-in-cross-device-design "Some lessons learned in cross-browser-design").

#rapidui

##- a toolkit for effective CSS / HTML development and rapid prototyping in-the-browser.

What it consists of: a HTML5&CSS3 framework for managing layouts and a number of utility scripts.

###<a href="#grid">1080px Grid System</a>
###Scripts

* <a href="https://github.com/abbottjam/rapidui/tree/master/css/css_manager">CSS Manager:</a>
 a script for combining, de-commenting, and compressing CSS files for faster, automated deployment.

<h2><a name="grid">The Grid</a></h2>
A small HTML&CSS framework designed around the following principles:

1. Both fixed and flexible layouts must be possible;
2. Flexible layouts must be built on a fluid grid (more on <a href="http://www.alistapart.com/articles/fluidgrids/"> fluid grids</a>);
3. Flexible layouts must be infinitely nestable (more on <a href="http://www.flickr.com/photos/nicole_hugo/3291776052/">
nestable grids and the Arnaud Gueras test</a>);
4. Maximum separation of concerns between CSS attributes, especially classes (more on
<a href="http://en.wikipedia.org/wiki/Separation_of_concerns"> separation of concerns</a>);
5. Minimal markup and CSS for layouts of any complexity.

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
        <code>.rowContainer</code>:
        Achieves horizontal breaks and vertical rhythm between layout elements;
        groups together cells in the grid. This is the "row" element.
    </li>
    <li>
        <code>.[1-12]Col</code>:
        The 12 column elements corresponding to the 12-column division, with the addition of
        <code>.wideCol</code> and <code>.narrowCol</code>, corresponding to the wide and narrow
        divisions of the Golden Section, respectively.
    </li>
    <li>
        <code>.group</code>:
        For containing floats. I'm using Tony Aslett's clearfix method here; see http://www.positioniseverything.net/easyclearing.html
    </li>
    <li>
        <code>.wrapper</code>:
        For centering layout elements. This element is what is commonly referred to as the "container". In rapidui,
    </li>
</ol>

###The main hack

The grid system uses a [CSS3 substring matching attribute selector](http://www.w3.org/TR/css3-selectors/
"CSS3 selector spec") to achieve grouping of cells:

<code>.rowContainer>*[class$="Col"]</code>

This means that any element with the class attribute value ending with "Col" will be treated as a cell
in the grid. The actual dimensions of the cell element is declared for each individual element,
ie a class tagged with <code>.rowContainer</code> only takes care of the floating and margins.

Together, an element tagged with <code>.rowContainer</code> containing a number of <code>*Col</code>
elements constitute what is known in Object-Oriented CSS terminology as an "object":

     <div class="rowContainer">
        <div class="sixCol"></div>
        <div class="sixCol"></div>
     </div>

Here, a "row" div contains two six-column cells to achieve a 2-column layout.

An "object" is a reusable HTML module that consists of a parent element with dependent child elements; the
relationship between the parent and the child elements is declared in CSS to achieve context-independence
and reuse. In DOM terminology, an "OOCSS object" it is a subtree of a web page's DOM tree that is not dependent
on its context and therefore demonstrates consistent behavior independent of where it is in the DOM tree.

See [What is meant by an "object" in OOCSS?](https://github.com/stubbornella/oocss/wiki/FAQ
"Explanation of the OOCSS "object" concept") for an example.

Thanks to this separation of concern, nesting grids is easy in rapidui. Just tag any cell with the <code>.rowContainer</code> class:

    <div class="rowContainer">
        <div class="sixCol"></div>
        <div class="rowContainer sixCol">
            <div class="fourCol"></div>
            <div class="fourCol"></div>
            <div class="fourCol"></div>
        </div>
    </div>

Here, the second 6-column cell is itself a container of three four-column cells. We can continue the subdivision forever:

    <div class="rowContainer">
        <div class="sixCol"></div>
        <div class="rowContainer sixCol">
            <div class="fourCol"></div>
            <div class="rowContainer fourCol">
                <div class="sixCol"></div>
                <div class="sixCol"></div>
            </div>
            <div class="fourCol"></div>
        </div>
    </div>

This eliminates the need for declaring a separate "row" or "line" div for each level of nesting,
[as is done](https://github.com/stubbornella/oocss/wiki/Lines-&-Grids "Nesting grids in OOCSS")
in the original OOCSS framework.

**NOTE:** The CSS3 selector specification reads:

> E[foo$="bar"] an E element whose "foo" attribute value ends exactly with the string "bar".

Because of this rule, the list of values for the "class" attribute must end with [*Col]. If an element has only one class,
this is the default. When there are multiple class values the [*Col] value must be the last in the list. For example, here
the rule will be applied:

    <div class="rowContainer">
        <div class="foo twelveCol"></div>
    </div>

Whereas here, it will not:

    <div class="rowContainer">
        <div class="twelveCol foo"></div>
    </div>




