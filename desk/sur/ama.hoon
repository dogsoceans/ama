  ::  /sur/schooner-ama
::::
::
|%

+$  action
  $%
    :: user actions
    [%question text=@t]
    [%answer text=@t index=@ud]
    [%change-image png=@t]
    [%change-bio text=@t]
    [%change-name text=@t]
    :: admin actions
    [%set-firewall =firewall]
    [%delete index=@ud]
  ==
::


+$  firewall-setting
  ?(%block-self)
+$  firewall
  (unit firewall-setting)

+$  update
  $%
    [%risen values=(list @)]

  ==
::
+$  qa
  $:
    question=@t
    answer=@t  
  ==
+$  inbox
  inbox=(list qa)

--