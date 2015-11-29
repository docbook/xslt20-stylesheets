xquery version "1.0-ml";

module namespace mldb="http://docbook.org/vendor/marklogic/docbook";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare namespace db="http://docbook.org/ns/docbook";
declare namespace c="http://www.w3.org/ns/xproc-step";

declare option xdmp:mapping "false";

declare function mldb:to-html(
  $doc as document-node()
) as document-node()
{
  mldb:to-html($doc, map:map())
};

declare function mldb:to-html(
  $doc as document-node(),
  $params as map:map
) as document-node()
{
  mldb:to-html($doc, map:map(), ())
};

declare function mldb:to-html(
  $doc as document-node(),
  $params as map:map,
  $preprocess as item()?
) as document-node()
{
  mldb:to-html($doc, $params, $preprocess, ())
};

declare function mldb:to-html(
  $doc as document-node(),
  $params as map:map,
  $preprocess as item()?,
  $stylesheet as item()?
) as document-node()
{
  mldb:transform($doc, $params, $preprocess, $stylesheet,
                 "/DocBook/base/html/final-pass.xsl")
};

declare function mldb:to-fo(
  $doc as document-node()
) as document-node()
{
  mldb:to-fo($doc, map:map())
};

declare function mldb:to-fo(
  $doc as document-node(),
  $params as map:map
) as document-node()
{
  mldb:to-fo($doc, map:map(), ())
};

declare function mldb:to-fo(
  $doc as document-node(),
  $params as map:map,
  $preprocess as item()?
) as document-node()
{
  mldb:to-fo($doc, $params, $preprocess, ())
};

declare function mldb:to-fo(
  $doc as document-node(),
  $params as map:map,
  $preprocess as item()?,
  $stylesheet as item()?
) as document-node()
{
  mldb:transform($doc, $params, $preprocess, $stylesheet,
                 "/DocBook/base/fo/final-pass.xsl")
};

declare %private function mldb:transform(
  $doc as document-node(),
  $params as map:map,
  $preprocess as item()?,
  $stylesheet as item()?,
  $final-pass as xs:string
) as document-node()
{
  (: We assume XInclude processing has already been performed. :)
  let $xsl-00-logstruct := "/DocBook/base/preprocess/00-logstruct.xsl"
  let $logical-structure := xdmp:xslt-invoke($xsl-00-logstruct, $doc)

  let $xsl-10-db4to5 := "/DocBook/base/preprocess/10-db4to5.xsl"
  let $db4to5 := if ($logical-structure/db:*)
                 then $logical-structure
                 else xdmp:xslt-invoke($xsl-10-db4to5, $logical-structure)

  let $xsl-20-transclude := "/DocBook/base/preprocess/20-transclude.xsl"
  let $transclude := xdmp:xslt-invoke($xsl-20-transclude, $db4to5)

  let $document-parameters := map:map()
  let $_ := for $param in $transclude//db:info/c:param[@name]
            let $qname := if ($param/@namespace)
                          then fn:QName($param/@namespace, $param/@name)
                          else if (contains($param/@name, ':'))
                               then fn:resolve-QName($param/@name, $param)
                               else fn:QName("", $param/@name)
            let $key := if (namespace-uri-from-QName($qname) = "")
                        then local-name-from-QName($qname)
                        else "{" || namespace-uri-from-QName($qname) || "}"
                             || local-name-from-QName($qname)
            return
              map:put($document-parameters, $key, $param/@value/string())

  let $params := map:new(($params, $document-parameters))

  let $xsl-30-profile := "/DocBook/base/preprocess/30-profile.xsl"
  let $profile := xdmp:xslt-invoke($xsl-30-profile, $transclude, $params)

  let $xsl-40-schemaext := "/DocBook/base/preprocess/40-schemaext.xsl"
  let $schemaext := xdmp:xslt-invoke($xsl-40-schemaext, $profile)

  let $xsl-50-normalize := "/DocBook/base/preprocess/50-normalize.xsl"
  let $normalize := xdmp:xslt-invoke($xsl-50-normalize, $schemaext)

  let $xsl-60-annotations := "/DocBook/base/preprocess/60-annotations.xsl"
  let $annotations := xdmp:xslt-invoke($xsl-60-annotations, $normalize)

  let $xsl-xlinklb := "/DocBook/base/xlink/xlinklb.xsl"
  let $ex-linkbases := xdmp:xslt-invoke($xsl-xlinklb, $annotations)

  let $xsl-xlinkex := "/DocBook/base/xlink/xlinkex.xsl"
  let $inline-xlinks := xdmp:xslt-invoke($xsl-xlinkex, $ex-linkbases)

  let $processed := xdmp:xslt-eval($inline-xlinks, $ex-linkbases, $params)

  let $doc := if (empty($preprocess))
              then $processed
              else if ($preprocess instance of document-node())
                   then xdmp:xslt-eval($preprocess, $processed, $params)
                   else if ($preprocess instance of element())
                   then xdmp:xslt-eval(document { $preprocess },
                                       $processed, $params)
                   else xdmp:xslt-invoke($preprocess, $processed, $params)

  let $result := if (empty($stylesheet))
                 then xdmp:xslt-invoke($final-pass, $doc)
                 else if ($stylesheet instance of document-node())
                      then xdmp:xslt-eval($stylesheet, $doc, $params)
                      else if ($stylesheet instance of element())
                      then xdmp:xslt-eval(document { $stylesheet },
                                          $doc, $params)
                      else xdmp:xslt-invoke($stylesheet, $doc, $params)
  return
    $result
};
