  ::  /app/ama
::::
::
/-  *ama
/+  dbug,
    default-agent,
    *ama,
    server,
    verb
/*  image  %jpeg  /app/hurricane/jpeg
/*  htmx-js  %js  /app/htmx/js
/*  ui  %html  /app/ui/html
/*  style-css  %css  /app/style/css

|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      values=(list @)
  ==
+$  card  card:agent:gall
--
%+  verb  &
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
    aux      ~(. +> bowl)
++  on-init
  ^-  [(list card) _this]
  ~&  >  "%ama initialized successfully."
  :-  :~  [%pass /eyre/connect %arvo %e %connect [~ /[dap.bowl]] dap.bowl]
      ==
  this
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  [(list card) _this]
  :-  ^-  (list card)
      ~
  %=  this
    state  !<(state-0 old)
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  [(list card) _this]
  =^  cards  state
    ?+    mark  (on-poke:default mark vase)
        %ama-action
      (take-action !<(action vase))
        %handle-http-request
      (http-handler !<([@ta inbound-request:eyre] vase))
    ==
  [cards this]
::
++  on-peek
  |=  path=(pole knot)
  ^-  (unit (unit cage))
  ?+    path  (on-peek:default path)
    [%x %value idx=@ ~]  [~ ~ [%noun !>((snag idx.path values))]]
    [%x %values ~]  [~ ~ [%noun !>(values)]]
  ==
++  on-watch
   |=  =path
  ^-  (quip card _this)
  ?+    path
    (on-watch:default path)
  ::
      [%http-response *]
    %-  (slog leaf+"Eyre subscribed to {(spud path)}." ~)
    `this
  ==
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    sign-arvo  (on-arvo:default [wire sign-arvo])
      [%eyre %bound *]
    ?:  accepted.sign-arvo
      %-  (slog leaf+"/{(trip dap.bowl)} bound successfully!" ~)
      [~ this]
    %-  (slog leaf+"Binding /{(trip dap.bowl)} failed!" ~)
    [~ this]
  ==
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
::
::  Helper Core
::
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
::
++  take-action
  |=  act=action
  ^-  [(list card) _state]
  [~ state]
::
++  http-handler
|=  [eyre-id=@ta =inbound-request:eyre]
^-  (quip card _state)
    ~&  [eyre-id inbound-request:eyre]
    ?+    method.request.inbound-request
      =/  data=octs
        (as-octs:mimes:html image)
      =/  content-length=@t
        (crip ((d-co:co 1) p.data))
      =/  =response-header:http
        :-  405
        :~  ['Content-Length' content-length]
            ['Content-Type' 'text/html']
        ==
      =/  =simple-payload:http  [response-header `data]
      :_  state
      %+  give-simple-payload:app:server
      eyre-id
      simple-payload

    ::
        %'GET'
      =/  data=octs
        (as-octs:mimes:html image)
      =/  content-length=@t
        (crip ((d-co:co 1) p.data))
      =/  =response-header:http
        :-  200
        :~  ['Content-Length' content-length]
            ['Content-Type' 'image/jpeg']
        ==
      :_  state
      (give-simple-payload:app:server eyre-id [response-header `data])

        %'POST'
      =/  data=octs
        (as-octs:mimes:html image)
      =/  content-length=@t
        (crip ((d-co:co 1) p.data))
      =/  =response-header:http
        :-  200
        :~  ['Content-Length' content-length]
            ['Content-Type' 'image/jpeg']
        ==
      :_  state
      (give-simple-payload:app:server eyre-id [response-header `data])
    ==
  



::
++  send-update
  |=  =term
  ^-  [(list card) _state]
  :-  :~  [%give %fact ~ %ama-update !>(`update`[%risen values])]
      ==
  state
--
