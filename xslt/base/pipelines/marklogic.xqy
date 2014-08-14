xquery version "1.0-ml";

module namespace dbp="http://docbook.github.com/ns/marklogic/pipeline";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare variable $syntax-highlighter-default-browser := "1";
declare variable $syntax-highlighter-default-print := "0";

declare variable $stylesheets :=
  ("../preprocess/00-logstruct.xsl",
   "../preprocess/10-db4to5.xsl",
   "../preprocess/20-transclude.xsl",
   "../preprocess/30-profile.xsl",
   "../preprocess/40-schemaext.xsl");

declare function dbp:for-browser(
  $source as document-node()
) as document-node()
{
  dbp:for-browser($source, map:map())
};

declare function dbp:for-browser(
  $source as document-node(),
  $params as map:map
) as document-node()
{
  dbp:for-browser($source, $params, $syntax-highlighter-default-browser)
};

declare function dbp:for-browser(
  $source as document-node(),
  $params as map:map,
  $highlight as xs:string
) as document-node()
{
  let $syntax-highlighter := (map:get($params, "syntax-highlighter"),
                              $highlight)[1]
  let $_ := map:put($params, "syntax-highlighter", $syntax-highlighter)
  let $doc := dbp:prepare-document($source, $params)
  return
    xdmp:xslt-invoke("../html/final-pass.xsl", $doc, $params)
};

declare function dbp:for-print(
  $source as document-node()
) as document-node()
{
  dbp:for-print($source, map:map())
};

declare function dbp:for-print(
  $source as document-node(),
  $params as map:map
) as document-node()
{
  dbp:for-print($source, $params, $syntax-highlighter-default-browser)
};

declare function dbp:for-print(
  $source as document-node(),
  $params as map:map,
  $highlight as xs:string
) as document-node()
{
  let $syntax-highlighter := (map:get($params, "syntax-highlighter"),
                              $highlight)[1]
  let $_ := map:put($params, "syntax-highlighter", $syntax-highlighter)
  let $doc := dbp:prepare-document($source, $params)
  return
    xdmp:xslt-invoke("../print/final-pass.xsl", $doc, $params)
};

declare function dbp:prepare-document(
  $source as document-node()
) as document-node()
{
  dbp:prepare-document($source, map:map())
};

declare function dbp:prepare-document(
  $source as document-node(),
  $params as map:map
) as document-node()
{
  let $syntax-highlighter := (map:get($params, "syntax-highlighter"),
                             $syntax-highlighter-default-browser)[1]
  let $styles  := ($stylesheets,
                   if (xs:decimal($syntax-highlighter) = 0)
                   then
                     "../preprocess/45-verbatim.xsl"
                   else
                     (),
                   "../preprocess/50-normalize.xsl",
                   "../xlink/xlinklb.xsl")
  let $doc     := dbp:apply-stylesheets($source, $params, $styles)
  let $inline  := xdmp:xslt-invoke("../xlink/xlinkex.xsl", $doc)
  return
    xdmp:xslt-eval($inline, $doc)
};

declare private function dbp:apply-stylesheets(
  $source as document-node(),
  $params as map:map,
  $stylesheets as xs:string*
) as document-node()
{
  if (empty($stylesheets))
  then
    $source
  else
    dbp:apply-stylesheets(
      xdmp:xslt-invoke($stylesheets[1], $source, $params),
      $params,
      subsequence($stylesheets,2))
};