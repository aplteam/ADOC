# ADOC

ADOC stand for Automated DOCumentation. It analyzes Dyalog APL Classes, Interfaces and namespace scripts and generates documentation from that. 
That documentation be enriched by adding Markdown to the Class, Interface or namespace script as comments.

The project lives on <https://github.com/aplteam/ADOC>

## Samples

```
      ]?ADoc
Command "TOOLS.ADoc". Syntax:                                                                  
Accepts modifiers -browser= -summary[=] -title=                                                
 Modifier 'summary' accepts only values "full"                                                 
                                                                                               
Automated documentation generation                                                             
]??ADoc   ⍝ for syntax details                                                                 
]???ADoc  ⍝ to view the complete ADoc documentation in a browser window                        
                                                                                               
Script location: ...                                                                                               

      ]??ADoc
Command "TOOLS.ADoc". Syntax:                                                                      
Accepts modifiers -browser= -summary[=] -title=                                                    
 Modifier 'summary' accepts only values "full"                                                     
                                                                                                   
Gathers information about one or more classes and/or namespaces.                                   
Either compiles an HTML page which is then displayed in a browser (default) or prints summarizing  
information to the session (-summary).                                                             
                                                                                                   
 -title={text}    Add a custom title with the content {text}                                       
 -browser={path}  Use the non-default browser specified                                            
 -summary[=full]  Return summarized information about the object members (optionally including full
                  functions headers)                                                               
                                                                                                   
Examples:                                                                                          
    ]ADoc MyClass                          ⍝ single class                                          
    ]ADoc MyClass FilesAndDirs             ⍝ two classes                                           
    ]ADoc MyClass -title="My Doc"          ⍝ custom title                                          
    ]ADoc MyClass -browser="c:\opera.exe"  ⍝ custom browser                                        
    ]ADoc MyClass -summary                 ⍝ basic info about #.MyClass                            
                                                                                                   
]???ADoc  ⍝ to view the complete ADoc documentation in a browser window                            
                                                                                                   
Script location: ...

      ]???ADoc

⍝ Shows extensive information about ADOC in your default browser.
```

## ADOC as a User Command

With version 16.0 `]ADOC` became an official Dyalog user command.
