xquery version "1.0-ml";

module namespace dbml="http://docbook.org/vendor/marklogic/locales";

declare namespace l="http://docbook.sourceforge.net/xmlns/l10n/1.0";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

(: ======================================================================

This module provides functions for loading locales for MarkLogic server.

1. You can put the locales in another database, specify the path to
   them with $dbml:database and $dbml:database-path. You must setup
   the appropriate privileges and amp to allow unprivileged users to
   access them.

2. You can put them in the modules directory of your application,
   specify the path to them with $dbml:modules-path. This option only
   works if your application is using a modules database; it will not
   work if the modules are stored on the filesystem. You must setup
   the appropriate privileges and amp to allow unprivileged users to
   access them.

3. You can put them on the filesystem, specify $dbml:filesystem-path
   to where they can be loaded. You must setup the appropriate
   privileges and amp to allow unprivileged users to access them.

4. You can put the locales in your content database, specify the
   path to them with $dbml:content-path

If none of these options is useful, you can override the
f:check-locale and f:load-locale functions in an XSLT customization
and the the data from anywhere you wish.

====================================================================== :)

declare variable $dbml:trace-event    := "docbook-locales";
declare variable $dbml:use-database   := true();
declare variable $dbml:use-modules    := true();
declare variable $dbml:use-filesystem := true();
declare variable $dbml:use-content    := true();

declare variable $dbml:database       := "DocBook.locales";
declare variable $dbml:database-path  := "/DocBook/locales";

(: Does not start with a slash, will be appended to xdmp:modules-root() :)
declare variable $dbml:modules-path   := "DocBook/base/common/locales";

declare variable $dbml:filesystem-path
        := "/opt/MarkLogic/Modules/DocBook/base/common/locales";

declare variable $dbml:content-path  := "/DocBook/locales";

(: Cache what we find, so we don't have to do it more than once... :)
declare %private variable $dbml:locale-map := map:map();

declare %private function dbml:load-locale-database(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path := concat($dbml:database-path, "/", $lang, ".xml")
  let $db   := xdmp:database($dbml:database)
  return
    dbml:load-from-database($path, $db)
};

declare %private function dbml:load-locale-modules(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path := concat(xdmp:modules-root(), $dbml:modules-path, "/", $lang, ".xml")
  let $db   := xdmp:modules-database()
  return
    if ($db = 0)
    then
      ()
    else
      dbml:load-from-database($path, $db)
};

declare %private function dbml:load-from-database(
  $path as xs:string,
  $db as xs:unsignedLong
) as element(l:l10n)?
{
  let $query   := concat("doc('", $path, "')")
  let $_       := trace(concat("Loading locale from ",
                               xdmp:database-name($db), " database: ",
                               $path), $dbml:trace-event)
  let $opts    := <options xmlns="xdmp:eval">
                    <database>{$db}</database>
                  </options>
  return
    xdmp:eval($query, (), $opts)/l:l10n
};

declare %private function dbml:load-locale-local(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path    := concat($dbml:database-path, "/", $lang, ".xml")
  let $dbname  := xdmp:database-name(xdmp:database())
  let $_       := trace(concat("Loading locale from ",
                               $dbname, " database: ",
                               $path), $dbml:trace-event)
  return
    doc($path)/l:l10n
};

declare %private function dbml:load-locale-filesystem(
  $lang as xs:string
) as element(l:l10n)?
{
  let $path  := concat($dbml:filesystem-path, "/", $lang, ".xml")
  let $_     := trace(concat("Loading filesystem locale: ", $path),
                      $dbml:trace-event)
  return
    xdmp:document-get($path)/l:l10n
};

declare %private function dbml:load-locale-any(
  $lang as xs:string
) as element(l:l10n)?
{
  try {
    xdmp:security-assert("http://docbook.org/vendor/marklogic/docbook-locales",
                         "execute"),

    let $db-l10n     := if ($dbml:use-database and exists($dbml:database)
                            and exists($dbml:content-path))
                        then
                          try {
                            dbml:load-locale-database($lang)
                          } catch ($e) {
                            let $_ := trace($e, $dbml:trace-event)
                            return
                              ()
                          }
                        else
                          ()

    let $module-l10n := if ($dbml:use-modules and empty($db-l10n))
                        then
                          try {
                            dbml:load-locale-modules($lang)
                          } catch ($e) {
                            let $_ := trace($e, $dbml:trace-event)
                            return
                              ()
                          }
                        else
                          $db-l10n

    let $fs-l10n     := if ($dbml:use-filesystem and empty($module-l10n))
                        then
                          try {
                            dbml:load-locale-filesystem($lang)
                          } catch ($e) {
                            let $_ := trace($e, $dbml:trace-event)
                            return
                              ()
                          }
                        else
                          $module-l10n

    let $l10n       := if ($dbml:use-content and empty($fs-l10n))
                        then
                          try {
                            dbml:load-locale-local($lang)
                          } catch ($e) {
                            let $_ := trace($e, $dbml:trace-event)
                            return
                              ()
                          }
                        else
                          $fs-l10n
    return
      $l10n
  } catch ($e) {
    (: Something went wrong, possibly the security assertion; the
       only unprivileged fallback is to attempt to load the locale
       from the content database. :)
    let $_ := trace($e, $dbml:trace-event)
    return
      if ($dbml:use-content)
      then
        try {
          dbml:load-locale-local($lang)
        } catch ($e) {
          let $_ := trace($e, $dbml:trace-event)
          return
            ()
        }
      else
        ()
  }
};

declare function dbml:check-locale(
  $lang as xs:string
) as xs:boolean
{
  if (empty(map:get($dbml:locale-map, $lang)))
  then
    let $l10n := dbml:load-locale($lang)
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
) as element(l:l10n)?
{
  let $l10n := map:get($dbml:locale-map, $lang)
  return
    if (empty($l10n))
    then
      let $check := if ($dbml:use-modules or $dbml:use-content
                        or $dbml:use-database or $dbml:use-filesystem)
                    then
                      ()
                    else
                      error((), concat("DocBook stylesheets misconfigured: ",
                                       "you must select at least one method ",
                                       "for loading localization data."))
      let $l10n := dbml:load-locale-any($lang)
      return
        if (empty($l10n))
        then
          () (: bang :)
        else
          (map:put($dbml:locale-map, $lang, $l10n), $l10n)
    else
      $l10n
};
