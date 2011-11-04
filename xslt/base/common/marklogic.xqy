xquery version "1.0-ml";

module namespace dbml="http://docbook.github.com/ns/marklogic";

import module namespace plugin="http://marklogic.com/extension/plugin"
       at "/MarkLogic/plugin/plugin.xqy";

declare namespace l="http://docbook.sourceforge.net/xmlns/l10n/1.0";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

(: ============================================================

This module provides functions for loading locales for MarkLogic server.

1. The easiest option is to install the localization plugins in
   Assets/plugins/docbook.

2. You can specify the $dbml:database and dbml:path where locales
   are installed in a database. The caller must have xdmp:eval privs
   if you specify a $dbml:database; otherwise the locales must be
   in the database associated with the appserver.

3. You can specify the $dbml:filesystem-path where they can be loaded
   with xdmp:document-get. The caller must have privs for that too.

If none of these options is useful, you can override the f:check-locale
and f:load-locale functions in an XSLT customization and the the data
from anywhere you wish.

   ============================================================ :)


declare variable $dbml:debug := false();
declare variable $dbml:database := ();
declare variable $dbml:path := "/locales";
declare variable $dbml:filesystem-path := "/MarkLogic/Modules/DocBook/base/common/locales";

(: I don't know if loading the plugin is expensive, but cache the results anyway :)
declare private variable $dbml:locale-map := map:map();

declare private function dbml:_load-locale-plugin(
  $lang as xs:string
) as element(l:l10n)?
{
  let $trace   := if ($dbml:debug) then xdmp:log(concat("Loading plugin locale: ", $lang)) else ()
  let $scope   := plugin:initialize-scope("docbook")
  let $capuri  := concat("http://docbook.org/localization/", $lang)
  let $plugins := plugin:plugins($capuri, "docbook")
  let $cap     := plugin:capability($capuri, $plugins[1], "docbook")
  return
    xdmp:apply($cap)/self::l:l10n
};

declare private function dbml:_load-locale-database(
  $lang as xs:string
) as element(l:l10n)?
{
  let $query   := concat("doc('", $dbml:path, "/", $lang, ".xml')")
  let $trace   := if ($dbml:debug) then xdmp:log(concat("Loading ", $dbml:database, " locale: ", $lang)) else ()
  let $opts    := <options xmlns="xdmp:eval"><database>{xdmp:database($dbml:database)}</database></options>
  return
    xdmp:eval($query, (), $opts)/l:l10n
};

declare private function dbml:_load-locale-local(
  $lang as xs:string
) as element(l:l10n)?
{
  let $trace   := if ($dbml:debug) then xdmp:log(concat("Loading locale: ", $lang)) else ()
  return
    doc(concat($dbml:path, "/", $lang, ".xml"))/l:l10n
};

declare private function dbml:_load-locale-filesystem(
  $lang as xs:string
) as element(l:l10n)?
{
  let $trace   := if ($dbml:debug) then xdmp:log(concat("Loading filesystem locale: ", $lang)) else ()
  return
    xdmp:document-get(concat($dbml:filesystem-path, "/", $lang, ".xml"))/l:l10n
};

declare private function dbml:_load-locale(
  $lang as xs:string
) as element(l:l10n)?
{
  let $l10n := try {
                 dbml:_load-locale-plugin($lang)
               } catch ($e) {
                 try {
                   if (empty($dbml:database))
                   then
                     dbml:_load-locale-local($lang)
                   else
                     dbml:_load-locale-database($lang)
                 } catch ($e) {
                   if ($dbml:debug) then xdmp:log($e) else ()
                 }
               }
  return
    if (empty($l10n))
    then
      try { dbml:_load-locale-filesystem($lang) }
      catch ($e) { () }
    else
      $l10n
};

declare function dbml:check-locale(
  $lang as xs:string
) as xs:boolean
{
  if (empty(map:get($dbml:locale-map, $lang)))
  then
    let $l10n := dbml:_load-locale($lang)
    return
      if (empty($l10n))
      then
        false()
      else
        (map:put($dbml:locale-map, $lang, $l10n), true())
  else
    true()
};

declare function dbml:load-locale(
  $lang as xs:string
) as element(l:l10n)
{
  let $l10n := map:get($dbml:locale-map, $lang)
  return
    if (empty($l10n))
    then
      let $l10n := dbml:_load-locale($lang)
      return
        if (empty($l10n))
        then
          () (: bang :)
        else
          (map:put($dbml:locale-map, $lang, $l10n), $l10n)
    else
      $l10n
};
