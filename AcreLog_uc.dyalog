:Class  AcreLog
⍝ User Command script for "AcreLog".
⍝ Expects the WS AcreLog.dws to be a sibling of this script.
⍝
⍝ 1.0.0  2019-12-11 kai  The `List` function now investigates the version of APL

    ⎕IO←⎕ML←1

    ∇ r←List
      :Access Shared Public
      r←⎕NS''
	  :If 17≤{⊃⊃(//)⎕vfi ⍵/⍨2>+\'.'=⍵}(⎕IO+1)⊃# ⎕wg 'APLVersion'  ⍝ We need at least 17.0 because of the HTMLRenderer
		  r.Group←'TOOLS'
		  r.Name←'AcreLog'	
		  r.Parse←'-fl'
		  r.Desc←'Monitors the acre "log" variable with a GUI'
	  :Else
		  r←''
	  :EndIf
    ∇

    ∇ r←Run(Cmd Args);bool;calledFrom;forceLoadFlag
      :Access Shared Public
      :If 0<≢r←CheckForProperVersionOfDyalog 2⊃# ⎕WG'APLVersion'
          :Return
      :EndIf
      forceLoadFlag←Args.Switch'fl'
      :If forceLoadFlag
      :OrIf 0=⎕SE.⎕NC'AcreLog'
          'AcreLog'⎕SE.⎕NS''
          :If 0<≢r←LoadAcreLog ##.SourceFile
              ⎕SE.⎕EX'AcreLog'
              :Return
          :EndIf
      :EndIf
      r←⎕SE.AcreLog.AcreLog.Run Args
    ∇

    ∇ r←l Help Cmd
      :Access Shared Public
      r←''
      :If 0=l
          r,←⊂List.Desc
      :Else
          r,←⊂'Allows you to put acre''s "log" variable on display with a GUI (HTMLRenderer object).'
          r,←⊂'Depending on your work flow you might find this more convinent than watching it with ⎕ED.'
          r,←⊂'The user command creates a namespace "AcreLog" within ⎕SE and then copies the workspace'
          r,←⊂'AcreLog" into it. That means you should avoid saving the session after executing ]AcreLog.'
          r,←⊂'You can enforce a re-load by specifying the -fl (force load) flag.'
      :EndIf
    ∇

    ∇ r←LoadAcreLog path;filename;path;ws;failed
      r←''
      ws←'AcreLog.dws'
      path←{⍵↓⍨-⌊/'\/'⍳⍨⌽⍵}path
      filename←path,'/',ws
      failed←1
      :Trap 11
          ⎕SE.AcreLog.⎕CY filename  ⍝ Standalone AcreLog expects WS to be a sibling of this script
          failed←0
      :Else
          :Trap 11
              ⎕SE.AcreLog.⎕CY ws       ⍝ Make use of Dyalog workspace search path
              failed←0
          :EndTrap
          r←failed/'Cannot find ',ws,' in ',path
      :EndTrap
    ∇

      CheckForProperVersionOfDyalog←{
          17≤{⊃(//)⎕VFI ⍵/⍨2>+\⍵='.'}⍵:''
          'This user command needs at least version 17.0 of Dyalog'
      }

:EndClass ⍝ AcreLog
