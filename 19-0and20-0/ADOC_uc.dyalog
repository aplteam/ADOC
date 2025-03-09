:Namespace ADOC
⍝ User Command script for "ADOC".
⍝ Tells the user to install ADOC as a Tatin package in [MyUCMDs]
⍝ This is a temporary solution for 19.0 and 20.0; it's required because
⍝ with these versions, Tatin is an option that is available only after
⍝ activating Tatin with the ]Activate user command.

    ⎕IO←⎕ML←1

    ∇ r←List
      r←⎕NS''
      r.Group←'TOOLS'
      r.Name←'ADoc'
      r.Parse←''
      r.Desc←'Automated documentation generation'
    ∇

    ∇ r←Run(Cmd Args)
      r←⍪GetInfo ⍬
    ∇

    ∇ r←l Help Cmd;filename
      r←GetInfo ⍬
    ∇
	
    ∇ r←GetInfo dummy
      r←''
      r,←⊂']ADoc is now a Tatin package, and can only be used by installing it as a Tatin package:'
      r,←⊂''
      r,←IsTatinAvailable↓⊂'    ]Activate all                           ⍝ this activates Tatin (and Cider)'
      r,←⊂'    ]InstallPackages [tatin]adoc [myucmds]  ⍝ this installs ]ADoc'
      r,←⊂''
      r,←⊂'After that, the ]ADoc user command will become available.'
    ∇
	
    ∇ r←IsTatinAvailable;cacheFilename;data
      cacheFilename←⎕SE.SALTUtils.UCMDCACHEFILE,⍨⊃⎕NPARTS ¯1↓⎕SE.Dyalog.StartupSession.VerSpec
      :If ~⎕NEXISTS cacheFilename   ⍝ If there is no user command cache we create one
          ⎕SE.SALTUtils.ResetUCMDcache ¯1
      :EndIf
      data←ReadComponentFile cacheFilename
      r←(⊂'tatin')∊data[;1]
    ∇
	
    ∇ data←ReadComponentFile filename;tie
      tie←filename ⎕FSTIE 0
      data←⎕FREAD tie 2
      ⎕FUNTIE tie
    ∇

:EndNamespace
