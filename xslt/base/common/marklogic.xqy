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

declare variable $dbml:debug          := false();
declare variable $dbml:use-modules    := false();
declare variable $dbml:use-plugins    := false();
declare variable $dbml:use-database   := false();
declare variable $dbml:use-filesystem := false();

declare variable $dbml:database       := "DocBook";
declare variable $dbml:database-path  := "/DocBook/locales";

(: Does not start with a slash, will be appended to xdmp:modules-root() :)
declare variable $dbml:modules-path  := "DocBook/base/common/locales";

declare variable $dbml:filesystem-path
        := "/opt/MarkLogic/Modules/DocBook/base/common/locales";

declare variable $dbml:PLUGIN-SCOPE := "docbook.locales";
declare variable $dbml:PLUGIN-COUNT-FIELD
        := "http://docbook.github.com/ns/marklogic/formatter/plugin-count";

(: I don't know if loading the plugin is expensive, but cache the results anyway :)
declare private variable $dbml:locale-map := map:map();

declare private function dbml:_load-locale-plugin(
  $lang as xs:string
) as element(l:l10n)?
{
  let $trace   := if ($dbml:debug)
                  then xdmp:log(concat("Loading docbook.locales plugin: ", $lang))
                  else ()
  let $scope   := plugin:initialize-scope($dbml:PLUGIN-SCOPE)
  let $capuri  := concat("http://docbook.org/localization/", $lang)
  let $plugins := plugin:plugins($capuri, $dbml:PLUGIN-SCOPE)
  let $cap     := plugin:capability($capuri, $plugins[1], $dbml:PLUGIN-SCOPE)
  return
    xdmp:apply($cap)/self::l:l10n
};

declare private function dbml:_load-locale-database(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path := concat($dbml:database-path, "/", $lang, ".xml")
  let $db   := xdmp:database($dbml:database)
  return
    dbml:_load-from-database($path, $db)
};

declare private function dbml:_load-locale-modules(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path := concat(xdmp:modules-root(), $dbml:modules-path, "/", $lang, ".xml")
  let $db   := xdmp:modules-database()
  return
    dbml:_load-from-database($path, $db)
};

declare private function dbml:_load-from-database(
  $path as xs:string,
  $db as xs:unsignedLong
) as element(l:l10n)?
{
  let $query   := concat("doc('", $path, "')")
  let $trace   := if ($dbml:debug)
                  then xdmp:log(concat("Loading locale from ",
                                       xdmp:database-name($db), " database: ",
                                       $path))
                  else ()
  let $opts    := <options xmlns="xdmp:eval">
                    <database>{$db}</database>
                  </options>
  return
    xdmp:eval($query, (), $opts)/l:l10n
};

declare private function dbml:_load-locale-local(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path    := concat($dbml:database-path, "/", $lang, ".xml")
  let $dbname  := xdmp:database-name(xdmp:database())
  let $trace   := if ($dbml:debug)
                  then xdmp:log(concat("Loading locale from ",
                                       $dbname, " database: ",
                                       $path))
                  else ()
  return
    doc($path)/l:l10n
};

declare private function dbml:_load-locale-filesystem(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path  := concat($dbml:filesystem-path, "/", $lang, ".xml")
  let $trace := if ($dbml:debug)
                then xdmp:log(concat("Loading filesystem locale: ", $path))
                else ()
  return
    xdmp:document-get($path)/l:l10n
};

declare private function dbml:_load-locale(
  $lang as xs:string
) as element(l:l10n)?
{
  let $module-l10n := if ($dbml:use-modules)
                      then
                        try {
                          dbml:_load-locale-modules($lang)
                        } catch ($e) {
                          if ($dbml:debug) then xdmp:log($e) else ()
                        }
                      else
                        ()

  let $plugin-l10n := if ($dbml:use-plugins)
                      then
                        try {
                          dbml:_load-locale-plugin($lang)
                        } catch ($e) {
                          if ($dbml:debug) then xdmp:log($e) else ()
                        }
                      else
                        $module-l10n

  let $db-l10n     := if ($dbml:use-database and exists($dbml:database)
                          and empty($plugin-l10n))
                      then
                        try {
                          dbml:_load-locale-database($lang)
                        } catch ($e) {
                          if ($dbml:debug) then xdmp:log($e) else ()
                        }
                      else
                        $plugin-l10n

  let $fs-l10n     := if ($dbml:use-filesystem and empty($db-l10n))
                      then
                        try {
                          dbml:_load-locale-filesystem($lang)
                        } catch ($e) {
                          if ($dbml:debug) then xdmp:log($e) else ()
                        }
                      else
                        $db-l10n

  let $l10n       := if (empty($fs-l10n))
                      then
                        try {
                          dbml:_load-locale-local($lang)
                        } catch ($e) {
                          if ($dbml:debug) then xdmp:log($e) else ()
                        }
                      else
                        $fs-l10n
  return
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

declare function dbml:check-plugins-loaded(
) as xs:integer
{
  xdmp:security-assert("http://docbook.github.com/ns/marklogic/formatter",
                       "execute"),

  let $curr-plugins := if ($dbml:debug)
                       then -1
                       else xdmp:get-server-field($dbml:PLUGIN-COUNT-FIELD, -1)

  return
    if ($curr-plugins ge 0)
    then
      $curr-plugins
    else
      xdmp:set-server-field-privilege(
        $dbml:PLUGIN-COUNT-FIELD,
        "http://docbook.github.com/ns/marklogic/formatter"
      ),
      xdmp:set-server-field(
        $dbml:PLUGIN-COUNT-FIELD,
        try {
          sum(for $scope in $dbml:PLUGIN-SCOPE
              return plugin:install-from-filesystem($dbml:PLUGIN-SCOPE))
          } catch ($e) {
            xdmp:log(concat(
              "could not initialize DocBook plugins with scope: ",
              $dbml:PLUGIN-SCOPE,": ", xdmp:quote($e))),
            0
          }
      )
};

declare function dbml:load-locale(
  $lang as xs:string
) as element(l:l10n)?
{
  let $l10n := map:get($dbml:locale-map, $lang)
  return
    if (empty($l10n))
    then
      let $check := if ($dbml:use-modules or $dbml:use-plugins
                        or $dbml:use-database or $dbml:use-filesystem)
                    then
                      ()
                    else
                      error((), concat("DocBook stylesheets misconfigured: ",
                                       "you must select at least one method ",
                                       "for loading localization data."))

      let $plugins := if ($dbml:use-plugins)
                      then dbml:check-plugins-loaded()
                      else ()
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
