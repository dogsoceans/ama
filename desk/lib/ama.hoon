  ::  /lib/ama
::::
::
/-  *ama
|%
++  spout  ::  build full response cards
  |=  [eyre-id=@ta simple-payload:http]
  ^-  (list card)
  =/  =path  /http-response/[eyre-id]
  :~  [%give %fact ~[path] [%http-response-header !>(response-header)]]
      [%give %fact ~[path] [%http-response-data !>(data)]]
      [%give %kick ~[path] ~]
  ==
--
