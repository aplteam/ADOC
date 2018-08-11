Advanced ADOC
-------------

This document addresses the advanced features of ADOC which can only be used when ADOC it loaded into a workspace; these features are **not** available when ADOC is used as a user command.

In order to use the advanced features of ADOC you must either load `ADOC.dws` or coy `ADOC` from this workspace. You find it in a folder ADOC\ which is a sibling of where you've installed the ADOC user command.


## Main method

The equivalent of the `]ADoc` user command is a call to the `#.ADOC.Browse` method. This method takes one or more references pointing to the classes, interfaces and namespaces `ADOC` is supposed to extract documentation from. 

Optionally one can specify a parameter space as left argument to `ADOC.Browse`.

The funcion returns the filename of the HTML file as a shy result.


Parameter space
---------------

A parameter space is by definition a namespace that carries variables recognized by `ADOC` as parameters. Such a namespace can be created by `⎕NS` and then populated with variables.

However, it is recommended to call `ADOC.CreateBrowseDefaults` which returns such a namespace populated with all the variables `ADOC` would recognize with
reasonable defaults which you change in order to make them suit your needs. Such a namespace can then be passed as left argument to the `Browse` method.


### Reserved names
Since version 3.0 `ADOC` looks for a number of fixed names. If there is a function with such a name to be found that function is executed and the
result returned by that function is taken into account. The reserved names are `Version`, `History` and `Copyright`.

In case there happens to be a function in a class that has other purposes than delivering information for ADOC then you cen set the `ignoreCopyright`, `ignoreHistory` and `ignoreVersion` parameters to 1. That prevent `ADOC` from treating those functions as outlined earlier.


### Embedded classes
If you would like to create an HTML report on embedded classes within a host
class you can do this by setting `embeddedClassesFlag←1` within a [parameter space](#Parameter space).

Note that this feature is currently not available when ADOC is used as a user command.


### CSS Style sheets
With version 1.4 the way style sheets are used has changed: `ADOC` now
creates its own style sheets dynamically.


### Friendly Classes
Friendly classes are classes which can see each other's private members. For the time being they are not available in Dyalog. However, depending on the application
friendly classes might be indispensable. As circumvention one can use naming conventions to achieve this. For example, you could define that all methods, fields and properties with names starting with an underscore are "friendly".

You can tell `ADOC` to suppress all members with such a pattern by defining:

~~~
My.IgnorePattern←'_'
~~~

Note that for the time being that can only be a string. This restriction may be lifted in a later version, for example by allowing a regular expression.

## Prevent `Browse` from displaying the HTML

`Browse` is perfect for creating and displaying information regarding a particular script or namespace, but sometimes you might want to create permanent HTML files and collect them for other purposes than to view them. `Browse` returns the name of the file created as a shy result, but you might also want to prevent `Browse` from putting that page on display.

You can achieve that by setting the `view` parameter to 0.


## Advanced techniques: take full control

One **can** gain full control by creating an instance of `ADOC`, setting parameters appropriately and then calling particular methods. However, this
is quite a complex task, and normally there is no need to do this.

Let's look at an example.

~~~
My←⎕NEW #.ADOC
My.(FullDocName Caption)←'test.htm' 'My Main Header'
My.Analyze scriptname       : Writes to the "Meta" property
My.CreateHtml ⍬             : Writes to the "HTML property
My.FinaliseHtml ⍬           : Add header+footer+prepare the final HTML
My.SaveHtml2File ⍬|filename : Write the HTML code to the disk
~~~

After calling `Analyze` you can look at the result by accessing the read-only property `Meta`. You can also create the HMTL code by calling `CreateHtml`
and then manipulate the `HTML` property which holds that code.

Author: Kai Jaeger ⋄ APL Team Ltd ⋄ <http://aplteam.com>

Homepage: <https://github.com/aplteam/ADOC>