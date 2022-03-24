# ADOC

ADOC stand for Automated DOCumentation. It analyzes Dyalog APL Classes, Interfaces and namespaces, scripted as well as non-scripted ones, and generates documentation from them. 
That documentation can be enriched by adding Markdown to the Class, Interface or namespace script as comments.

## Samples

```
      ]ADoc -?
───────────────────────────────────────────────────────────────────────────────
                                                                               
]TOOLS.ADoc                                                                    
Source: /path/to/ADOC_uc.dyalog                          
Version: 2.391                                                                 
Syntax:                                                                        
Accepts modifiers -browser= -ref= -summary[=] -title= -toc= -filename= -version           
 Modifier 'ref' accepts values consisting only of characters in the set "0 1"  
 Modifier 'summary' accepts only values "full"                                 
 Modifier 'toc' accepts values consisting only of characters in the set "0 1"  
                                                                               
Automated documentation generation                                             
]ADoc -??  ⍝ for syntax details                                                
]ADoc -??? ⍝ to view the complete ADoc documentation in a browser window       
                                                                               

      ]ADoc -??
───────────────────────────────────────────────────────────────────────────────                                           
]TOOLS.ADoc

Source: /path/tpADOC_uc.dyalog                                                                    
Version: 2.391

Syntax:

Accepts modifiers -browser= -ref= -summary[=] -title= -toc= -filename= -version

 Modifier 'ref' accepts values consisting only of characters in the set "0 1"
 Modifier 'summary' accepts only values "full"
 Modifier 'toc' accepts values consisting only of characters in the set "0 1"
 Modifier Default is a temp filename but allows any filename

Gathers information about one or more classes and/or namespaces.                                                          

Either compiles an HTML page which is then displayed in a browser (default) or prints
summarizing information to the session (-summary).

 -title={text}    Add a custom title with the content {text}
 -browser={path}  Use the non-default browser specified
 -summary[=full]  Returns summarized information about the object members (optionally including full function headers)
 -version         Returns the version number of ADOC used. If specified everythings else is ignored

When objects are not addressed with a full name (= start neither with `#` nor with `⎕SE` then the user command will try to find the     
objects in the namespace the user command was called from. If they cannot be found there it will assume they live in `#`.               

Examples:                                                                                                                               
    ]ADoc MyClass                              ⍝ single class
    ]ADoc MyClass FilesAndDirs                 ⍝ two classes                                  
    ]ADoc MyClass -title="My Doc"              ⍝ custom title
    ]ADoc MyClass -browser="c:\opera.exe"      ⍝ custom browser
    ]ADoc MyClass -summary                     ⍝ basic info
    ]ADoc MyClass -summary=full                ⍝ more detailed info                           

]ADoc -??? ⍝ to view the complete ADoc documentation in a browser window                                          
```

## ADOC as a User Command

With version 16.0 `]ADOC` became an official Dyalog user command.
