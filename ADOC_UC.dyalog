:Class  ADOC ⍝ V2.391
⍝ User Command script for "ADOC".
⍝ Expects the WS ADOC.dws to be a sibling of this script.
⍝
⍝ 2017 06 05 Adam: ]help → ]info; "parms" → "params"; ]help → -help
⍝ 2017 06 07 Adam: disable ]CreateParams; "List" → "Info"
⍝ 2017 06 14 Adam: ]browse → ]TOOLS.adoc; -help → ]???adoc; ]info [-full] → ]adoc -info[=full]
⍝ 2017 06 14 Adam: args are now separated with space instead of commas; -info handles multiple names and includes -title
⍝ 2017 05 15 KaiJ: -caption → -title
⍝ 2017 06 13 KaiJ:  -params and ]CreateParms removed; help fixed; documentation updated.
⍝ 2017 06 15 Adam: -info → -summary, now accepts relative refs, help tweak, removed error trapping
⍝ 2017 06 22 KaiJ: Bug fix regarding Caption/Title + make it compatible with pre-16.0 versions.
⍝ 2017 06 26 KaiJ: Documentation shortened. Sub-folder ADOC introduced. CSS for print improved.
⍝ 2017 06 27 KaiJ: Sub-folder removed.
⍝ 2018 04 18 Adam: ]??cmd → ]cmd -??
⍝ 2018 05 01 Adam: Add SVN tag

    ⎕IO←⎕ML←1

    ∇ r←List
      :Access Shared Public
      r←⎕NS''
      r.(Group Name Parse)←'TOOLS' 'ADoc' '-title= -browser= -summary[=]full'
      r.Desc←'Automated documentation generation'
    ∇

    ∇ r←Run(Cmd Args);bool;calledFrom
      :Access Shared Public
      ⍝ We now create a namespace ⎕SE.ADOC but keep it local to this function!
      ⍝ This code CANNOT run in a sub-function!
      ⎕SE.⎕SHADOW'ADOC'
      ⎕SE.⎕EX'ADOC'
      'ADOC'⎕SE.⎕NS''
      LoadAdoc ##.SourceFile
      :If ∨/bool←'##.'∘{⍺≡(⍴⍺)↑⍵}¨Args.Arguments
          calledFrom←{⊃⍵↓⍨'⎕SE'{+/∧\⍺∘≡¨(⍴⍺)↑¨⍵}⍵}⎕NSI
          (bool/Args.Arguments)←calledFrom∘{⍺,'.',⍵}¨bool/Args.Arguments
      :EndIf
      :If 0≢Args.summary
          r←AdocInfo Args
      :Else
          r←AdocBrowse Args
      :EndIf
    ∇

    ∇ r←l Help Cmd
      :Access Shared Public
      r←''
      :Select l
      :Case 0
          r,←⊂List.Desc
      :Case 1
          r,←⊂'Gathers information about one or more classes and/or namespaces.'
          r,←⊂'Either compiles an HTML page which is then displayed in a browser (default) or prints summarizing information to the session (-summary).'
          r,←⊂''
          r,←⊂' -title={text}    Add a custom title with the content {text}'
          r,←⊂' -browser={path}  Use the non-default browser specified'
          r,←⊂' -summary[=full]  Return summarized information about the object members (optionally including full functions headers)'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂'    ]',Cmd,' MyClass                              ⍝ single class'
          r,←⊂'    ]',Cmd,' MyClass FilesAndDirs                 ⍝ two classes'
          r,←⊂'    ]',Cmd,' MyClass -title="My Doc"              ⍝ custom title'
          r,←⊂'    ]',Cmd,' MyClass -browser="c:\opera.exe"      ⍝ custom browser'
          r,←⊂'    ]',Cmd,' MyClass -summary                     ⍝ basic info'
          r,←⊂'    ]',Cmd,' MyClass -summary=full                ⍝ more detailed info'
          r,←⊂''
      :Else
          ⎕SE.⎕SHADOW'ADOC'
          ⎕SE.⎕EX'ADOC'
          'ADOC'⎕SE.⎕NS''
          LoadAdoc ##.##.c
          r←⊂'HTML page saved as ',⎕SE.ADOC.ADOC.ShowDocumentation ⍬
      :EndSelect
      r,←(l≠1)/⊂']',Cmd,' -??  ⍝ for syntax details'
      r,←(l≤1)/⊂']',Cmd,' -??? ⍝ to view the complete ADoc documentation in a browser window'
    ∇

      Split←{
          ⍺←⎕UCS 13 10 ⍝ Default is CR+LF
          (⍴,⍺)↓¨⍺{⍵⊂⍨⍺⍷⍵}⍺,⍵
      }

    ∇ ref←CheckRefs ref;parent
      :If (⊃ref)∊'⎕#'
          :If ~(⎕NC ref)∊3 4
              ref←{6::⍬ ⋄ ⍎⍵}ref
          :EndIf
      :Else
          :If 9=#.⎕NC ref   ⍝ Is it in the root?
              parent←#
          :Else
              parent←⍎⊃{(+/∧\'⎕'=⊃¨⍵)↓⍵}⎕NSI
          :EndIf
          :If 9=parent.⎕NC ref
              ref←parent⍎ref
          :Else
              ('Not found: ',ref)⎕SIGNAL 6
          :EndIf
      :EndIf
    ∇

    ∇ r←AdocBrowse Args;title;ref;cs;browser;params
      title←''Args.Switch'title' ⍝ default is empty
      browser←''Args.Switch'browser' ⍝ default is empty      
      params←⍎'⎕SE.ADOC.ADOC.CreateBrowseDefaults'Args.Switch'params'
      :If ~0∊⍴browser
          params.BrowserPath←browser
      :EndIf
      :If ~0∊⍴title
          params.Title←title
      :EndIf
      ref←CheckRefs¨Args.Arguments
      :If ∨/⍬∘≡¨ref
          r←'Invalid right argument'
          :Return
      :EndIf
     
      params ⎕SE.ADOC.ADOC.Browse ref      ⍝ <=== workhorse
     
      r←'Watch your browser'
    ∇

    ∇ r←AdocInfo Args;option;ref;nl;full;parent
      'You must specify a class or namespace'⎕SIGNAL 11/⍨0∊⍴Args.Arguments
      nl←⎕UCS 13
      full←1≢Args.summary
      r←''
      :If 0≢Args.title
          r,←Args.title,nl
          r,←nl nl nl,⍨'─'⊣¨Args.title
      :EndIf
      :For ref :In Args.Arguments
          :If 16>{⍎⍵/⍨1≥+\⍵='.'}(1+⎕IO)⊃#.APLVersion
              parent←(⎕SI⍳⊂'UCMD')⊃⎕RSI
              r,←nl nl nl,⍨full ⎕SE.ADOC.ADOC.Info parent⍎ref
          :Else
              r,←nl nl nl,⍨full ⎕SE.ADOC.ADOC.Info(⎕SI⍳⊂'UCMD')(86⌶)ref
          :EndIf
      :EndFor
      r↓⍨←¯3
    ∇

    ∇ {r}←LoadAdoc path;filename;path;ws;failed
      r←⍬
      ws←'ADOC.dws'
      path←{⍵↓⍨-⌊/'\/'⍳⍨⌽⍵}path
      filename←path,'/',ws
      failed←1
      :Trap 11
          ⎕SE.ADOC.⎕CY filename  ⍝ Standalone ADOC expects WS to be a sibling of this script
          failed←0
      :Else
          :Trap 11
              ⎕SE.ADOC.⎕CY ws       ⍝ Make use of Dyalog workspace search path
              failed←0
          :EndTrap
          (failed/6)⎕SIGNAL⍨'Cannot find ',ws,' in ',path
      :EndTrap
    ∇

:EndClass ⍝ ADOC  $Revision$
