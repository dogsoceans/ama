  ::  /app/ama
::::
::
/-  *ama
/+  dbug,
    default-agent,
    *ama,
    server,
    schooner,
    rudder,
    verb,
    sigil
/*  htmx  %js  /app/htmx/js
/*  ama-js  %js  /app/ama/js
/*  amazero  %html  /app/amazero/html
/*  style  %css  /app/style/css

|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  %0
      inbox
      image=(unit cord)
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
^-  [(list card) _state] ::removed list card cant poke  now
?+  -.act  `state
    %question
  =/  =qa  [+.act *@t]
  `state(inbox (snoc inbox qa))
  ::
    %answer
  =/  =qa  (snag index.act inbox)
  =.  answer.qa  text.act
  `state(inbox (snap inbox index.act qa))
    %delete 
  `state(inbox (oust [index.act 1] inbox))
    %change-bio 
  =/  put-name-in-state  state(name name.act)
  =/  put-bio-in-state  state(bio bio.act)
  =/  new-state  put-bio-in-state
  `new-state
==
::
:: double action handlers temp solution... 
:: http post request demands an action, but has wrong shape
::
++  action-handler2
|=  act=action
^-  [_state]
?+  -.act  state
    %question
  =/  =qa  [+.act *@t]
  state(inbox (snoc inbox qa))
  ::
    %answer
  =/  =qa  (snag index.act inbox)  
  =.  answer.qa  text.act
  state(inbox (snap inbox index.act qa))
    %delete 
  state(inbox (oust [index.act 1] inbox))
    %change-bio 
  
  =/  new-state  state(name name.act)
  =.  new-state  new-state(bio bio.act)
  ~&  image.act
  ?:  =(image.act '')
    =.  new-state  new-state(image ~)
    new-state
  =.  new-state  new-state(image [~ image.act])
  new-state
==

++  action-parser
  |=  body=(unit octs)
  ^-  $@(null action)
  =/  args=(map @t @t)
    ?~(body ~ (frisk q.u.body))
  ?:  (~(has by args) 'send')
    [%question (~(got by args) 'question-input')]
  ?:  (~(has by args) 'send-answer')
      [%answer (~(got by args) 'question-input') `@ud`(slav %ud (~(got by args) 'index'))]
  ?:  (~(has by args) 'index')
    [%delete `@ud`(slav %ud (~(got by args) 'index'))]
  ?:  (~(has by args) 'bio-update') ::standardize name 
    [%change-bio (~(got by args) 'name') (~(got by args) 'bio') (~(got by args) 'image')]
  ~
::
++  frisk  ::  parse url-encoded form args
  |=  body=@t
  %-  ~(gas by *(map @t @t))
  (fall (rush body yquy:de-purl:html) ~)
  
::
++  http-handler
|=  [eyre-id=@ta =inbound-request:eyre]
^-  (quip card _state)
=/  body  body.request.inbound-request
=/  =request-line:server 
  (parse-request-line:server url.request.inbound-request)
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
    ::send css and js
    ::
      [%apps %ama %ama ~]
    :_  state
    (send [200 ~ [%text-javascript ama-js]])
      [%apps %ama %htmx ~]
    :_  state
    (send [200 ~ [%text-javascript htmx]])

      [%apps %ama %style ~]
    :_  state
    (send [200 ~ [%text-css style]])
    ::
    :: main requests
    ::
      [%apps %ama ~]
    ?.  authenticated.inbound-request
      :_  state
      (send [200 ~ [%manx front-page]])
    :_  state
    (send [200 ~ [%manx admin-front-page]])
    ::
    ::  buttons
    ::
    [%apps %ama %inbox ~]
    ?.  authenticated.inbound-request
      :_  state
      (send [404 ~ [%plain "404 - Not Found"]])
    :_  state
    (send [200 ~ [%manx admin-inbox-page-body]])
    ::
    [%apps %ama %return ~]
    ?.  authenticated.inbound-request
      :_  state
      (send [404 ~ [%plain "404 - Not Found"]])
    :_  state
    (send [200 ~ [%manx admin-front-page-body]])
    ::
        [%apps %ama %settings ~]
    ?.  authenticated.inbound-request
      :_  state
      (send [404 ~ [%plain "404 - Not Found"]])
    :_  state
    (send [200 ~ [%manx admin-settings-page-front]])
        [%apps %ama %settings %inbox ~]
    ?.  authenticated.inbound-request
      :_  state
      (send [404 ~ [%plain "404 - Not Found"]])  :: change 2 front page body
    :_  state
    (send [200 ~ [%manx admin-settings-page-inbox]])
  == 
  ::
    %'POST'
  =/  act-p  (action-parser body)
  ~&  >  act-p
  ?+    site.request-line  
    ?~  act-p  `state
  :_  (action-handler2 act-p)
  (send [202 ~ %json [%o p=[n=[p='message' q=[%s p='Post request successful']] l=~ r=~]]])
      [%apps %ama %bio ~]
    ?.  authenticated.inbound-request
        ?~  act-p  `state
          :_  (action-handler2 act-p)
        (send [404 ~ [%plain "404 - Not Found"]]) 
      ?~  act-p  `state
         :_  (action-handler2 act-p)
       (send [200 ~ [%manx admin-front-page-body]]) 
  ==
==

::
++  send-update
  |=  =term
  ^-  [(list card) _state]
  `state
:: 


++  html-head
^-  manx
;head
  ;meta(charset "UTF-8");
  ;meta(name "viewport", content "width=device-width, initial-scale=1.0");
  ;title:"Ask Me Anything"
  ;link(rel "stylesheet", href "ama/style.css");
  ;script(src "ama/htmx.js");
==

::
++  copy-icon
^-  manx
;svg
  =class  "copy-icon"
  =width  "32px"
  =height  "32px"
  =viewBox  "-2.4 -2.4 28.80 28.80"
  =fill  "none"
  =xmlns  "http://www.w3.org/2000/svg"
  =stroke  "#000000"
    ;path
      =d  "M14 7V7C14 6.06812 14 5.60218 13.8478 5.23463C13.6448 4.74458 13.2554 4.35523 12.7654 4.15224C12.3978 4 11.9319 4 11 4H8C6.11438 4 5.17157 4 4.58579 4.58579C4 5.17157 4 6.11438 4 8V11C4 11.9319 4 12.3978 4.15224 12.7654C4.35523 13.2554 4.74458 13.6448 5.23463 13.8478C5.60218 14 6.06812 14 7 14V14"
      =stroke  "#000000"
      =stroke-width  "2";
    ;rect
      =x  "10"
      =y  "10"
      =width  "10"
      =height  "10"
      =rx  "2"
      =stroke  "#000000"
      =stroke-width  "2";
==

++  inbox-icon
^-  manx
;svg
  =class  "inbox-icon"
  =hx-get  "/apps/ama/inbox"
  =hx-target  "body"
  =hx-swap  "outerHTML"
  =xmlns  "http://www.w3.org/2000/svg"
  =version  "1.1"
  =x  "0px"
  =y  "0px"
  =width  "32px"
  =height  "32px"
  =viewBox  "0 0 100 125"
    ;path
      =d  "M12.5,90h75c1.381,0,2.5-1.119,2.5-2.5v-50c0-0.723-0.371-1.498-0.938-1.952l-37.5-30c-0.913-0.73-2.21-0.73-3.123,0 l-37.5,30C10.371,36.002,10,36.777,10,37.5v50C10,88.881,11.119,90,12.5,90z M50,10.702L83.498,37.5L50,64.298L16.502,37.5 L50,10.702z M15,42.702l33.438,26.75c0.114,0.091,0.234,0.171,0.359,0.24c0.748,0.411,1.657,0.411,2.405,0 c0.125-0.068,0.245-0.148,0.359-0.24L85,42.702V85H15V42.702z"
      =fill  "#000000"
      =stroke  "#000000"
      =stroke-width  "2";
    ;path
      =d  "M51.768,49.268l10-10c0.977-0.976,0.977-2.559,0-3.535c-0.976-0.977-2.56-0.977-3.535,0L56.465,37.5L52.5,41.464V37.5v-10 c0-1.381-1.119-2.5-2.5-2.5s-2.5,1.119-2.5,2.5v10v3.964L43.535,37.5l-1.768-1.768c-0.976-0.977-2.56-0.977-3.535,0 c-0.977,0.976-0.977,2.559,0,3.535l10,10C48.72,49.756,49.36,50,50,50S51.28,49.756,51.768,49.268z"
      =fill  "#000000"
      =stroke  "#000000"
      =stroke-width  "2";
  ==
  
++  settings-icon
^-  manx
;svg
  =class  "settings-button"
  =hx-get  "/apps/ama/settings"
  =hx-target  "body"
  =hx-swap  "outerHTML"
  =xmlns  "http://www.w3.org/2000/svg"
  =width  "24px"
  =height  "24px"
  =fill  "none"
  =viewBox  "0 0 16 16"
    ;path
      =d  "m2.26726 6.15309c.26172-.80594.69285-1.54574 1.26172-2.1727.09619-.10602.24711-.14381.38223-.0957l1.35948.484c.36857.13115.77413-.06004.90584-.42703.01295-.03609.02293-.07316.02982-.1108l.259-1.41553c.02575-.14074.13431-.25207.27484-.28186.41118-.08714.83276-.13146 1.25987-.13146.42685 0 .84818.04427 1.25912.1313.14049.02976.24904.14102.27485.28171l.25973 1.41578c.07022.38339.43924.63751.82434.5676.0379-.00688.0751-.01681.1113-.02969l1.3595-.48402c.1351-.04811.286-.01032.3822.0957.5689.62696 1 1.36676 1.2618 2.1727.0441.13596.0015.28502-.1079.3775l-1.1019.93152c-.2983.25225-.3348.69756-.0815.99463.0249.02921.0522.05635.0815.08114l1.1019.93153c.1094.09248.152.24154.1079.37751-.2618.80598-.6929 1.54578-1.2618 2.17268-.0962.106-.2471.1438-.3822.0957l-1.3595-.484c-.3685-.1311-.7741.0601-.90581.427-.01295.0361-.02293.0732-.02985.111l-.25971 1.4157c-.02581.1407-.13436.2519-.27485.2817-.41094.087-.83227.1313-1.25912.1313-.42711 0-.84869-.0443-1.25987-.1315-.14053-.0298-.24909-.1411-.27484-.2818l-.25899-1.4155c-.07022-.3834-.43928-.6375-.82433-.5676-.03787.0069-.0751.0168-.11128.0297l-1.35954.484c-.13512.0481-.28604.0103-.38223-.0957-.56887-.6269-1-1.3667-1.26172-2.17268-.04415-.13597-.00158-.28503.10783-.37751l1.1019-.93152c.29835-.25225.33484-.69756.08151-.99463-.02491-.02921-.05217-.05635-.0815-.08114l-1.10191-.93153c-.10941-.09248-.15198-.24154-.10783-.3775zm3.98268 1.84685c0 .9665.7835 1.75 1.75 1.75s1.75-.7835 1.75-1.75-.7835-1.75-1.75-1.75-1.75.7835-1.75 1.75z"
      =fill  "#000000";
  ==
  ++  settings-icon-inbox
^-  manx
;svg
  =class  "settings-button2"
  =hx-get  "/apps/ama/settings/inbox"
  =hx-target  "body"
  =hx-swap  "outerHTML"
  =xmlns  "http://www.w3.org/2000/svg"
  =width  "24px"
  =height  "24px"
  =fill  "none"
  =viewBox  "0 0 16 16"
    ;path
      =d  "m2.26726 6.15309c.26172-.80594.69285-1.54574 1.26172-2.1727.09619-.10602.24711-.14381.38223-.0957l1.35948.484c.36857.13115.77413-.06004.90584-.42703.01295-.03609.02293-.07316.02982-.1108l.259-1.41553c.02575-.14074.13431-.25207.27484-.28186.41118-.08714.83276-.13146 1.25987-.13146.42685 0 .84818.04427 1.25912.1313.14049.02976.24904.14102.27485.28171l.25973 1.41578c.07022.38339.43924.63751.82434.5676.0379-.00688.0751-.01681.1113-.02969l1.3595-.48402c.1351-.04811.286-.01032.3822.0957.5689.62696 1 1.36676 1.2618 2.1727.0441.13596.0015.28502-.1079.3775l-1.1019.93152c-.2983.25225-.3348.69756-.0815.99463.0249.02921.0522.05635.0815.08114l1.1019.93153c.1094.09248.152.24154.1079.37751-.2618.80598-.6929 1.54578-1.2618 2.17268-.0962.106-.2471.1438-.3822.0957l-1.3595-.484c-.3685-.1311-.7741.0601-.90581.427-.01295.0361-.02293.0732-.02985.111l-.25971 1.4157c-.02581.1407-.13436.2519-.27485.2817-.41094.087-.83227.1313-1.25912.1313-.42711 0-.84869-.0443-1.25987-.1315-.14053-.0298-.24909-.1411-.27484-.2818l-.25899-1.4155c-.07022-.3834-.43928-.6375-.82433-.5676-.03787.0069-.0751.0168-.11128.0297l-1.35954.484c-.13512.0481-.28604.0103-.38223-.0957-.56887-.6269-1-1.3667-1.26172-2.17268-.04415-.13597-.00158-.28503.10783-.37751l1.1019-.93152c.29835-.25225.33484-.69756.08151-.99463-.02491-.02921-.05217-.05635-.0815-.08114l-1.10191-.93153c-.10941-.09248-.15198-.24154-.10783-.3775zm3.98268 1.84685c0 .9665.7835 1.75 1.75 1.75s1.75-.7835 1.75-1.75-.7835-1.75-1.75-1.75-1.75.7835-1.75 1.75z"
      =fill  "#000000";
  ==
::
++  settings-icon-check
^-  manx
;svg
  =class  "settings-button"
  =hx-post  "/apps/ama/bio"
  =hx-include  "#settings-form"
  =hx-target  "body"
  =hx-trigger  "click"
  =hx-swap  "outerHTML"
  =xmlns  "http://www.w3.org/2000/svg"
  =width  "24px"
  =height  "24px"
  =fill  "none"
  =viewBox  "0 0 16 16"
  ;path
    =d  "m2.26726 6.15309c.26172-.80594.69285-1.54574 1.26172-2.1727.09619-.10602.24711-.14381.38223-.0957l1.35948.484c.36857.13115.77413-.06004.90584-.42703.01295-.03609.02293-.07316.02982-.1108l.259-1.41553c.02575-.14074.13431-.25207.27484-.28186.41118-.08714.83276-.13146 1.25987-.13146.42685 0 .84818.04427 1.25912.1313.14049.02976.24904.14102.27485.28171l.25973 1.41578c.07022.38339.43924.63751.82434.5676.0379-.00688.0751-.01681.1113-.02969l1.3595-.48402c.1351-.04811.286-.01032.3822.0957.5689.62696 1 1.36676 1.2618 2.1727.0441.13596.0015.28502-.1079.3775l-1.1019.93152c-.2983.25225-.3348.69756-.0815.99463.0249.02921.0522.05635.0815.08114l1.1019.93153c.1094.09248.152.24154.1079.37751-.2618.80598-.6929 1.54578-1.2618 2.17268-.0962.106-.2471.1438-.3822.0957l-1.3595-.484c-.3685-.1311-.7741.0601-.90581.427-.01295.0361-.02293.0732-.02985.111l-.25971 1.4157c-.02581.1407-.13436.2519-.27485.2817-.41094.087-.83227.1313-1.25912.1313-.42711 0-.84869-.0443-1.25987-.1315-.14053-.0298-.24909-.1411-.27484-.2818l-.25899-1.4155c-.07022-.3834-.43928-.6375-.82433-.5676-.03787.0069-.0751.0168-.11128.0297l-1.35954.484c-.13512.0481-.28604.0103-.38223-.0957-.56887-.6269-1-1.3667-1.26172-2.17268-.04415-.13597-.00158-.28503.10783-.37751l1.1019-.93152c.29835-.25225.33484-.69756.08151-.99463-.02491-.02921-.05217-.05635-.0815-.08114l-1.10191-.93153c-.10941-.09248-.15198-.24154-.10783-.3775z"
    =fill  "#000000";
  ;path
    =d  "M10.5657 6.56569C10.8721 6.87207 10.8721 7.30083 10.5657 7.60721L8.10721 10.0657C7.80083 10.3721 7.37207 10.3721 7.06569 10.0657L5.56569 8.56569C5.25932 8.25932 5.25932 7.83056 5.56569 7.52419C5.87207 7.21782 6.30083 7.21782 6.60721 7.52419L7.5 8.41697L9.39279 6.52419C9.69917 6.21782 10.1279 6.21782 10.4343 6.52419C10.5657 6.56569 10.5657 6.56569 10.5657 6.56569Z"
    =fill  "white";
==
::
++  settings-icon-inbox-check
^-  manx
;svg
  =class  "settings-button2"
  =hx-get  "/apps/ama/inbox"
  =hx-target  "body"
  =hx-swap  "outerHTML"
  =xmlns  "http://www.w3.org/2000/svg"
  =width  "24px"
  =height  "24px"
  =fill  "none"
  =viewBox  "0 0 16 16"
  ;path
    =d  "m2.26726 6.15309c.26172-.80594.69285-1.54574 1.26172-2.1727.09619-.10602.24711-.14381.38223-.0957l1.35948.484c.36857.13115.77413-.06004.90584-.42703.01295-.03609.02293-.07316.02982-.1108l.259-1.41553c.02575-.14074.13431-.25207.27484-.28186.41118-.08714.83276-.13146 1.25987-.13146.42685 0 .84818.04427 1.25912.1313.14049.02976.24904.14102.27485.28171l.25973 1.41578c.07022.38339.43924.63751.82434.5676.0379-.00688.0751-.01681.1113-.02969l1.3595-.48402c.1351-.04811.286-.01032.3822.0957.5689.62696 1 1.36676 1.2618 2.1727.0441.13596.0015.28502-.1079.3775l-1.1019.93152c-.2983.25225-.3348.69756-.0815.99463.0249.02921.0522.05635.0815.08114l1.1019.93153c.1094.09248.152.24154.1079.37751-.2618.80598-.6929 1.54578-1.2618 2.17268-.0962.106-.2471.1438-.3822.0957l-1.3595-.484c-.3685-.1311-.7741.0601-.90581.427-.01295.0361-.02293.0732-.02985.111l-.25971 1.4157c-.02581.1407-.13436.2519-.27485.2817-.41094.087-.83227.1313-1.25912.1313-.42711 0-.84869-.0443-1.25987-.1315-.14053-.0298-.24909-.1411-.27484-.2818l-.25899-1.4155c-.07022-.3834-.43928-.6375-.82433-.5676-.03787.0069-.0751.0168-.11128.0297l-1.35954.484c-.13512.0481-.28604.0103-.38223-.0957-.56887-.6269-1-1.3667-1.26172-2.17268-.04415-.13597-.00158-.28503.10783-.37751l1.1019-.93152c.29835-.25225.33484-.69756.08151-.99463-.02491-.02921-.05217-.05635-.0815-.08114l-1.10191-.93153c-.10941-.09248-.15198-.24154-.10783-.3775z"
    =fill  "#000000";
  ;path
    =d  "M10.5657 6.56569C10.8721 6.87207 10.8721 7.30083 10.5657 7.60721L8.10721 10.0657C7.80083 10.3721 7.37207 10.3721 7.06569 10.0657L5.56569 8.56569C5.25932 8.25932 5.25932 7.83056 5.56569 7.52419C5.87207 7.21782 6.30083 7.21782 6.60721 7.52419L7.5 8.41697L9.39279 6.52419C9.69917 6.21782 10.1279 6.21782 10.4343 6.52419C10.5657 6.56569 10.5657 6.56569 10.5657 6.56569Z"
    =fill  "white";
==
::
++  return-icon
^-  manx
;svg
  =class  "return-icon"
  =hx-get  "/apps/ama/return"
  =hx-target  "body"
  =hx-swap  "outerHTML"
  =fill  "#000000"
  =height  "32px" 
  =width  "32px"
  =version  "1.1"
  =id  "Layer_1"
  =xmlns  "http://www.w3.org/2000/svg"
  =viewBox  "-49.07 -49.07 588.83 588.83"
  =stroke  "#000000"
  =stroke-width  "9.81386"
  ;path
    =d  "M351.173,149.227H36.4L124.827,60.8c4.053-4.267,3.947-10.987-0.213-15.04c-4.16-3.947-10.667-3.947-14.827,0 L3.12,152.427c-4.16,4.16-4.16,10.88,0,15.04l106.667,106.667c4.267,4.053,10.987,3.947,15.04-0.213 c3.947-4.16,3.947-10.667,0-14.827L36.4,170.56h314.773c65.173,0,118.187,57.387,118.187,128s-53.013,128-118.187,128h-94.827 c-5.333,0-10.133,3.84-10.88,9.067c-0.96,6.613,4.16,12.267,10.56,12.267h95.147c76.907,0,139.52-66.987,139.52-149.333 S428.08,149.227,351.173,149.227z";
==
++  send-inbox-icon
^-  manx
;svg
  =width  "32px"
  =height  "32px"
  =viewBox  "0 0 24 24"
  =fill  "none"
  =xmlns  "http://www.w3.org/2000/svg"
  ;path
    =d  "M10.3009 13.6949L20.102 3.89742M10.5795 14.1355L12.8019 18.5804C13.339 19.6545 13.6075 20.1916 13.9458 20.3356C14.2394 20.4606 14.575 20.4379 14.8492 20.2747C15.1651 20.0866 15.3591 19.5183 15.7472 18.3818L19.9463 6.08434C20.2845 5.09409 20.4535 4.59896 20.3378 4.27142C20.2371 3.98648 20.013 3.76234 19.7281 3.66167C19.4005 3.54595 18.9054 3.71502 17.9151 4.05315L5.61763 8.2523C4.48114 8.64037 3.91289 8.83441 3.72478 9.15032C3.56153 9.42447 3.53891 9.76007 3.66389 10.0536C3.80791 10.3919 4.34498 10.6605 5.41912 11.1975L9.86397 13.42C10.041 13.5085 10.1295 13.5527 10.2061 13.6118C10.2742 13.6643 10.3352 13.7253 10.3876 13.7933C10.4468 13.87 10.491 13.9585 10.5795 14.1355Z"
    =stroke  "#ffffff"
    =stroke-width  "2"
    =stroke-linecap  "round"
    =stroke-linejoin  "round";
==

++  delete-button-icon
^-  manx
;svg
  =width  "32px"
  =height  "32px"
  =viewBox  "0 0 1024 1024"
  =xmlns  "http://www.w3.org/2000/svg"
  =fill  "#ffffff"
  =stroke  "#ffffff"
  ;path
    =fill  "#ffffff"
    =d  "M195.2 195.2a64 64 0 0 1 90.496 0L512 421.504 738.304 195.2a64 64 0 0 1 90.496 90.496L602.496 512 828.8 738.304a64 64 0 0 1-90.496 90.496L512 602.496 285.696 828.8a64 64 0 0 1-90.496-90.496L421.504 512 195.2 285.696a64 64 0 0 1 0-90.496z";
==
::
++  send-inbox-button
^-  manx
;button.send-button
  ;+  send-inbox-icon
==
++  delete-inbox-button
^-  manx
;button(class "send-button", type "input", name "send-answer", value "send-answer")
  ;+  send-inbox-icon
==
::
++  profile-image
^-  manx
?~  image
;div(class "image")
  ;+  %.  our.bowl
      %_  sigil
        size    40
        fg      "white"
        bg      "black"
        margin  & 
        icon    &
      ==
  ==
;div.image
  ;img(src (trip u.image));
==

::
++  inbox-container
^-  manx
;div.inbox-container
  ;+  inbox-icon 
  ;div(class "copy-container", id "copyButton")
    copy sharable url
    ;+  copy-icon
  ==
==
::

::
++  return-container
^-  manx
;div.return-container
  ;+  return-icon 
==
::
++  front-page
^-  manx
;html
  ;+  html-head
  ;+  front-page-body
  ;script(src "ama/ama.js");
==
++  front-page-body
^-  manx
;body
  ;div.body-container
    ;div.space;
    ;div.question-container
      ;div.container-form
        ;div.container-form-header
          ;+  profile-image
          ;div(class "container-header-text")
            ;div(class "name")
              ;b: Ask: 
              ; {(trip ?:(=(name *@t) `@t`(scot %p ~zod) name))}
            ==
            ;div(class "bio"): {(trip bio.state)}
          ==
        ==
        ;form(id "question-form", hx-post "/apps/ama", hx-swap "none", hx-on--after-request "this.reset()")
          ;textarea(name "question-input", placeholder "ask ~nospur-sontud anything. . .", maxlength "140", required "");
        ==
      ==
      ;button(type "submit", form "question-form", name "send", value "send"): Send!
    ==
    ;*  
    %+  turn  inbox-answer
    |=  n=(pair qa @ud)
    ;div(class "qa-container")
      ;div(class "question")
        ;div.question-label: Q:  
        ;span(class "question-text"): {(trip question.p.n)}
      ==
      ;hr; 
      ;div(class "answer")
        ;div.answer-label: A:
        ;span(class "answer-text"): {(trip answer.p.n)}
      ==
      ;input(type "hidden", name "index", value "{<q.n>}");
    ==
  ==
  ;div.powered: powered by ~ urbit
== 
::
++  admin-front-page
^-  manx
;html
  ;+  html-head
  ;+  admin-front-page-body
  ;script(src "ama/ama.js");
==
++  admin-front-page-body
^-  manx
;body
  ;div.body-container
    ;+  inbox-container
    ;div.question-container
      ;div.container-form
        ;div.container-form-header 
          ;+  profile-image
          ;div(class "container-header-text")
            ;div(class "name")
              ;b: Ask: 
              ; {(trip ?:(=(name *@t) `@t`(scot %p ~zod) name))}
            ==
            ;div(class "bio"): {(trip bio.state)}
          ==
          ;+  settings-icon
        ==
        ;form(id "question-form", hx-post "/apps/ama", hx-swap "none", hx-on--after-request "this.reset()")
          ;textarea(name "question-input", placeholder "ask ~nospur-sontud anything. . .", maxlength "140", required "");
        ==
      ==
      ;button(type "submit", form "question-form", name "send", value "send"): Send!
    ==
    ;*  
    %+  turn  inbox-answer
    |=  n=(pair qa @ud)
    ;div(class "qa-container")
      ;div(class "question")
        ;div.question-label: Q:  
        ;span(class "question-text"): {(trip question.p.n)}
      ==
      ;hr; 
      ;div(class "answer")
        ;div.answer-label: A:
        ;span(class "answer-text"): {(trip answer.p.n)}
      ==
      ;input(type "hidden", name "index", value "{<q.n>}");
    ==
  ==
  ;div.powered: powered by ~ urbit
==

++  settings-form
^-  manx
=/  img  
  ?~  image  
    ''
  u.image
;form(id "settings-form")
  ;div
    ;label: Name  
    ;input(type "text", name "name", value "{(trip ?:(=(name *@t) `@t`(scot %p ~zod) name))}");
    ;label: Image 
    ;input(type "text", name "image", value "{(trip img)}", placeholder "http://your-image.png");
  ==
  ;div
    ;label: Bio 
    ;input(type "text", name "bio", value "{(trip bio.state)}");
    ;input(type "hidden", name "bio-update", value "bio-update");
  ==
==
::
::
++  admin-settings-page-front
^-  manx
;body
  ;div.body-container
    ;+  inbox-container
    ;div.question-container
      ;div.container-form
        ;div.container-form-header
          ;div(class "image")
          ;+  %.  our.bowl
              %_  sigil
                size    40
                fg      "white"
                bg      "black"
                margin  & 
                icon    &
              ==
          == 
          ;+  settings-form
          ;+  settings-icon-check
        ==
        ;form(id "question-form", hx-post "/apps/ama", hx-swap "none", hx-on--after-request "this.reset()")
          ;textarea(name "question-input", placeholder "ask ~nospur-sontud anything. . .", maxlength "140", required "");
        ==
      ==
      ;button(type "submit", form "question-form", name "send", value "send"): Send!
    ==
    ;*  
    %+  turn  inbox-answer
    |=  n=(pair qa @ud)
    ;div(class "qa-container")
      ;div(class "question")
        ;button(class "x-button", type "input", name "index", value "{<q.n>}", hx-post "/apps/ama/settings", hx-swap "delete", hx-target "closest .qa-container")
          ;+  delete-button-icon
        ==
        ;div.question-label: Q:  
          ;span(class "question-text"): {(trip question.p.n)}
        ==
      ;hr; 
      ;div(class "answer")
        ;div.answer-label: A:
        ;span(class "answer-text"): {(trip answer.p.n)}
      ==
    ==
  ==
  ;div.powered: powered by ~ urbit
==

++  admin-inbox-page-body
^-  manx
;body
  ;div.body-container
    ;div.return-container
    ;+  return-icon 
    ;+  settings-icon-inbox
    ==
    ;div.question-container
      ;*  
      %+  turn  inbox-question
      |=  q=[@t @ud]
      ;div.container-form
        ;div(class "question")
          ;div.question-label: Q:  
          ;span(class "question-text"): {(trip -.q)}
        ==
        ;form(id "question-form", hx-post "/apps/ama", hx-swap "delete", hx-target "closest .container-form")
          ;textarea(name "question-input", placeholder "A:");
          ;input(type "hidden", name "index", value "{<+.q>}");
          ;button(class "send-button", type "input", form "question-form", name "send-answer", value "send-answer")
            ;+  send-inbox-icon
          ==
        ==
      ==
    ==
  ==
  ;div.powered: powered by ~ urbit
==

++  admin-settings-page-inbox
^-  manx
;body
  ;div.body-container
    ;div.return-container
    ;+  return-icon 
    ;+  settings-icon-inbox-check
    ==
    ;div.question-container
      ;*  
      %+  turn  inbox-question
      |=  q=[@t @ud]
      ;div.container-form
        ;div(class "question")
          ;button(class "x-button", type "input", name "index", value "{<+.q>}", hx-post "/apps/ama", hx-swap "delete", hx-target "closest .container-form")
            ;+  delete-button-icon
          ==
          ;div.question-label: Q:  
          ;span(class "question-text"): {(trip -.q)}
        ==
        ;form(id "question-form", hx-post "/apps/ama", hx-swap "delete", hx-target "closest .container-form")
          ;textarea(name "question-input", placeholder "A:", required "");
          ;input(type "hidden", name "index", value "{<+.q>}");
          ;button(class "send-button", type "input", form "question-form", name "send-answer", value "send-answer")
            ;+  send-inbox-icon
          ==
        ==
      ==
    ==
  ==
  ;div.powered: powered by ~ urbit
==





++  inbox-answer
^-  (list (pair qa @ud))
=/  =^inbox  inbox
=|  ans-inbox=(list (pair qa @ud))
=/  counter=@ud  0
|-
?~  inbox.inbox
  ans-inbox
?:  =(answer.i.inbox.inbox *@t)
  $(inbox t.inbox.inbox, counter +(counter))
$(inbox t.inbox.inbox, counter +(counter), ans-inbox (snoc ans-inbox [i.inbox.inbox counter]))

++  inbox-question
^-  (list (pair @t @ud))
=/  =^inbox  inbox
=|  q-inbox=(list (pair @t @ud))
=/  counter=@ud  0
|-
?~  inbox.inbox
  q-inbox
?.  =(answer.i.inbox.inbox *@t)
  $(inbox t.inbox.inbox, counter +(counter))
$(inbox t.inbox.inbox, counter +(counter), q-inbox (snoc q-inbox [question.i.inbox.inbox counter]))


--
