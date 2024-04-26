  ::  /app/ama
::::
::
/-  *ama
/+  dbug,
    default-agent,
    *ama,
    server,
    schooner,
    verb
/*  image  %jpeg  /app/hurricane/jpeg
/*  htmx  %js  /app/htmx/js
/*  amazero  %html  /app/amazero/html
/*  style  %css  /app/style/css

|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      inbox
      image=@t
      bio=@t
      name=@t
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
  :-  :~  [%pass /eyre/connect %arvo %e %connect [~ /apps/[dap.bowl]] dap.bowl]
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
      (action-handler !<(action vase))
        %handle-http-request
      (http-handler !<([@ta inbound-request:eyre] vase))
    ==
  [cards this]
::
++  on-peek  on-peek:default
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
      %-  (slog leaf+"/apps/{(trip dap.bowl)} bound successfully!" ~)
      [~ this]
    %-  (slog leaf+"Binding /apps/{(trip dap.bowl)} failed!" ~)
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
++  action-handler
  |=  act=action
  ^-  [(list card) _state]
  [~ state]
::
++  http-handler
|=  [eyre-id=@ta =inbound-request:eyre]
^-  (quip card _state)
=/  =request-line:server 
  (parse-request-line:server url.request.inbound-request)
  ~&  >  request-line
=+  send=(cury response:schooner eyre-id)
::
?+    method.request.inbound-request  
  [(send [405 ~ [%stock ~]]) state]
  :: 
    %'GET'
  
  ?+    site.request-line  
      :_  state 
      (send [404 ~ [%plain "404 - Not Found"]])
    ::
      [%apps %ama %style ~]
    :_  state
    (send [200 ~ [%text-css style]])
    ::
      [%apps %ama ~]
    :_  state
    (send [200 ~ [%manx html-base]])
      [%apps %ama %htmx ~]
    :_  state
    (send [200 ~ [%text-javascript htmx]])
  == 
==
::
++  send-update
  |=  =term
  ^-  [(list card) _state]
  `state

++  html-base
^-  manx
;html(lang "en")
  ;head
    ;meta(charset "UTF-8");
    ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
    ;title:"Ask Me Anything"
    ;link(rel "stylesheet", href "ama/style.css");
    ;script(src "ama/htmx.js");
  ==
  ;body
    ;div(class "body-container");
  ==
==
--
