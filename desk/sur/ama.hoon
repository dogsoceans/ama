  ::  /sur/schooner-ama
::::
::
|%

+$  action
  $%
    :: user actions
    [%question text=@t]
    [%answer text=@t]
    [%change-image png=@t]
    [%change-bio text=@t]
    [%change-name text=@t]
    :: admin actions
    [%set-firewall =firewall]
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