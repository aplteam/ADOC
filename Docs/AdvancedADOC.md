[parm]:leanpubExtensions = 1
[parm]:title             = 'Advanced ADOCing'



Advanced ADOC
-------------

This document covers the advanced features of `ADOC` that can't be used via the user command.

For this to work `ADOC` must already to be loaded into `⎕SE`. 
This will only be the case if the `]ADoc` user command has been executed. 
Calling `]ADoc -???` is sufficient to achieve this.

A> ### Making sure that ADOC is loaded into `⎕SE` early
A>
A> If you want to make sure that `ADOC` is always already in `⎕SE` when an instance of Dyalog is started, then you have to add a line to `setup.dyalog` in the MyUCMDs folder, or add `setup.dylog` to the folder.
A>
A> See [About User Commands](https://aplwiki.com/wiki/Dyalog_User_Commands "Link to an article on the APL wiki") for details.

## Main method

The equivalent of the `]ADoc` user command is to call `⎕SE.ADOC.Browse`. This method takes one or more references pointing to the classes, interfaces and namespaces from which `ADOC` is supposed to extract documentation. 

The `Browse` function returns the filename of the HTML file as a shy result.

Optionally you can pass a parameter space as left argument to `⎕SE.ADOC.Browse`. This is what you need to do in order to do advanced stuff: via a parameter space you can specify options that are not available with the user command.


Parameter space
---------------

A parameter space is, by definition, a namespace that contains variables that `ADOC` recognizes as parameters. 

Such a namespace can be created by `⎕NS` and then populated with variables. However, it is recommended that you call `⎕SE.ADOC.CreateBrowseDefaults` which will return such a namespace populated with all the variables that `ADOC` would recognize with reasonable defaults that you can change in order to make them suit your needs. 


### Reserved names

Since version 3.0 `ADOC` looks for a number of fixed names. If there is a function with such a name is found that function is executed and the result returned by that function is taken into account. The reserved names are `Version`, `History` and `Copyright`.

If there happens to be a function in a class that has a purposes other than providing information for `ADOC`,  you can set the `ignoreCopyright`, `ignoreHistory` and `ignoreVersion` parameters to 1. This will prevent `ADOC` from treating these functions as described above.


### Embedded classes

If you wish to produce an HTML report on embedded classes within a host class, you can do this by setting `embeddedClassesFlag←1` within the parameter space.


### Friendly Classes

Friendly classes are classes that can see each other's private members. They are currently not available in Dyalog. 

However, depending on the application friendly classes may be indispensable. As a workaround you can use naming conventions to achieve something similar. For example, you could define that all methods, fields and properties with names starting with an underscore are "friendly".

You can tell `ADOC` to ignore all members with such a pattern by defining:

~~~
My.IgnorePattern←'_'
~~~

Note that this can only be a string for the time being. This restriction may be removed in a later version, for example by allowing a regular expression.

## Preventing `Browse` from displaying the HTML

`Browse` is perfect for creating and viewing information about a particular script or namespace, but sometimes you may want to create permanent HTML files and collect them for purposes other than viewing. 

`Browse` returns the name of the file created as a shy result, but you might also want to prevent `Browse` from displaying this page.

You can achieve that by setting the `view` parameter to 0.


## Advanced techniques: taking full control

You **can** take full control by creating an instance of `ADOC`, setting parameters and then calling certain methods. However, this is a rather complex task, and normally there is no need to do this.

Let's look at an example.

~~~
My←⎕NEW ⎕SE.ADOC
My.(FullDocName Caption)←'test.htm' 'My Main Header'
My.Analyze scriptname       ⍝ Writes to the "Meta" property
My.CreateHtml ⍬             ⍝ Writes to the "HTML property
My.FinaliseHtml ⍬           ⍝ Add header+footer+prepare the final HTML
My.SaveHtml2File filename   ⍝ Write the HTML code to the disk
~~~

After calling `Analyze` you can view the result by accessing the read-only property `Meta`. You can also create the HMTL code by calling `CreateHtml` and then manipulate the `HTML` property that holds this code.

Author: Kai Jaeger

Homepage: <https://github.com/aplteam/ADOC>