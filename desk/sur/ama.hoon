  ::  /sur/schooner-ama
::::
::
|%

+$  action
  $%
    :: user actions
    [%ask-question text=@t]
    [%comment reply-to=@ud text=@t]
    [%like like-to=@ud]
    :: admin actions
    [%delete post-id=@ud]
    [%set-firewall =firewall]
  ==
::

+$  update
  $%
    [%risen values=(list @)]
    [%reply reply-to=@ud reply=post]
    [%delete post-id=@ud]
  ==
::
+$  post
  $:
    id=@ud
    text=@t
    time=@da
    likes=@ud
  ==
+$  thread
  $:
    root=post
    replies=(list post)
  ==
--
