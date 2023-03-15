:Class  ADOC_uc ⍝ V3.000
⍝ User Command script for "ADOC".
⍝ 2023 03 14 Kai: Transformed into a Tatin packages plus plenty of improvements and fixes

    ⎕IO←⎕ML←1

    ∇ r←List
      :Access Shared Public
      r←⎕NS''
      r.Group←'TOOLS'
      r.Name←'ADoc'
      r.Parse←'-title= -browser= -summary[=]full -version -ref∊0 1 -toc∊0 1 -filename='
      r.Desc←'Automated documentation generation'
    ∇

    ∇ r←Run(Cmd Args);bool;calledFrom;wasLoaded
      :Access Shared Public
      wasLoaded←LoadAdoc ⍬
      :If Args.Switch'version'
          r←{⍵↓⍨+/∧\' '=⍵}⍕1↓⎕SE.ADOC.Version
      :Else
          :If ∨/bool←'##.'∘{⍺≡(⍴⍺)↑⍵}¨Args.Arguments
              calledFrom←{⊃⍵↓⍨'⎕SE'{+/∧\⍺∘≡¨(⍴⍺)↑¨⍵}⍵}⎕NSI
              (bool/Args.Arguments)←calledFrom∘{⍺,'.',⍵}¨bool/Args.Arguments
          :EndIf
          Args.Arguments←∪LocateStuff Args.Arguments
          :If 0≢Args.summary
              r←AdocInfo Args
          :Else
              r←AdocBrowse Args
          :EndIf
      :EndIf
      :If 0=wasLoaded
          ⍝ Unload? Always? Only on demand?
      :EndIf
    ∇

    ∇ {r}←LoadAdoc dummy
    ⍝ Loads ADOC into ⎕SE if it's not already there.
    ⍝ Returns 1 if it was loaded and 0 when it was already there
      :If 0=⎕SE.⎕NC'Tatin'
          :Trap 6
              {}⎕SE.UCMD'Tatin.Version'
          :Else
              'Tatin is not available and cannot be loaded into ⎕SE, therefore ADOC can''t be loaded'Assert 0
          :EndTrap
      :EndIf
      :If r←0=⎕SE.⎕NC'ADOC'
          {}⎕SE.Tatin.LoadDependencies(⊃⎕NPARTS ##.SourceFile)'⎕SE'
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
          r,←⊂' -title={text}    Add a custom title with the content {text}.'
          r,←⊂' -browser={path}  Use the non-default browser specified.'
          r,←⊂' -summary[=full]  Returns summarized information about the object members (optionally including full fn headers).'
          r,←⊂' -filename=       Modifier Default is a temp filename but allows any filename'
          r,←⊂' -version         Returns the version number of ADOC used. If specified everythings else is ignored.'
          r,←⊂''
          r,←⊂'When objects are not addressed with a full name (= start neither with `#` nor with `⎕SE`) then the user command '
          r,←⊂'will try to find the objects in the namespace the user command was called from. If they cannot be found there it '
          r,←⊂'will assume they live in `#`.'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂'    ]',Cmd,' MyClass                              ⍝ single class'
          r,←⊂'    ]',Cmd,' MyClass FilesAndDirs                 ⍝ two classes'
          r,←⊂'    ]',Cmd,' MyClass -title="My Doc"              ⍝ custom title'
          r,←⊂'    ]',Cmd,' MyClass -browser="c:\opera.exe"      ⍝ custom browser'
          r,←⊂'    ]',Cmd,' MyClass -summary                     ⍝ basic info'
          r,←⊂'    ]',Cmd,' MyClass -summary=full                ⍝ more detailed info'
          r,←⊂''
      :Case 2
          LoadAdoc ⍬
          r←⊂'HTML page saved as ',⎕SE.ADOC.ShowDocumentation ⍬
      :EndSelect
      r,←(l=0)/⊂']',Cmd,' -??  ⍝ for syntax details'
      r,←(l∊0 1)/⊂']',Cmd,' -??? ⍝ to view the complete ADoc documentation in a browser window'
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

    ∇ r←AdocBrowse Args;title;ref;cs;browser;params;includeRefeference;toc
      Args.Arguments←CheckArgumentsForTatin Args.Arguments
      title←''Args.Switch'title' ⍝ default is empty
      browser←''Args.Switch'browser' ⍝ default is empty
      includeRefeference←1 Args.Switch'ref'
      toc←1 Args.Switch'toc'
      params←⍎'⎕SE.ADOC.CreateBrowseDefaults'Args.Switch'params'
      :If 0≠≢browser
          params.BrowserPath←browser
      :EndIf
      :If 0≠≢title
          params.Title←title
      :EndIf
      params.IncludeReference←includeRefeference
      params.Toc←toc
      params.Filename←{(,0)≡,⍵:'' ⋄ ⍵}params.Filename
      'Nothing to process?!'⎕SIGNAL 6/⍨0=≢Args.Arguments
      ref←CheckRefs¨Args.Arguments
      :If ∨/⍬∘≡¨ref
          r←'Invalid right argument'
          :Return
      :EndIf
     
      params ⎕SE.ADOC.Browse ref      ⍝ <=== workhorse
     
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
          :If 16>{⍎⍵/⍨1≥+\⍵='.'}(1+⎕IO)⊃# ⎕WG'APLVersion'
              parent←(⎕SI⍳⊂'UCMD')⊃⎕RSI
              r,←nl nl nl,⍨full ⎕SE.ADOC.Info parent⍎ref
          :Else
              r,←nl nl nl,⍨full ⎕SE.ADOC.Info(⎕SI⍳⊂'UCMD')(86⌶)ref
          :EndIf
      :EndFor
      r↓⍨←¯3
    ∇

    ∇ r←LocateStuff r;i;this;type;calledFrom
      :For i :In ⍳≢r
          this←i⊃r
          :If ~(⊃this)∊'#⎕'
              type←⎕NC⊂'#.',this
              calledFrom←('⎕SE.'{+/∧\⍺∘≡¨(≢⍺)↑¨⍵}⎕XSI)⊃⎕RSI
              :If 9=calledFrom.⎕NC this
                  this←(⍕calledFrom),'.',this
              :Else
                  this←'#.',this
              :EndIf
          :EndIf
          (i⊃r)←this
      :EndFor
    ∇

    ∇ r←CheckArgumentsForTatin args;arg;name;ref;flag
      r←''
      :For arg :In args
          name←⍕ref←⍎arg
          :Trap 2
              flag←'_tatin'{⍺≡(≢⍺)↑⍵}{'#.'≡2⍴⍵:2↓⍵ ⋄ '⎕SE.'≡1 ⎕C 4⍴⍵:4↓⍵ ⋄ ⍵}name
          :Else
              flag←0
          :EndTrap
          :If flag
              name←⍕ref.##
              r,←⊂name
          :Else
              r,←⊂arg
          :EndIf
      :EndFor
    ∇

      IfAtLeastVersion←{
      ⍝ ⍵ is supposed to be a number like 15 or 17.1, representing a version of Dyalog APL.
      ⍝ Returns a Boolean that is 1 only if the current version is at least as good.
          ⍵≤{⊃(//)⎕VFI ⍵/⍨2>+\'.'=⍵}2⊃# ⎕WG'APLVersion'
      }

:EndClass ⍝ ADOC  $Revision$
