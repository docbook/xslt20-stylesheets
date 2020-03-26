package org.docbook

import com.xmlcalabash.XMLCalabashTask

import java.lang.reflect.Method

class DocBookTask extends XMLCalabashTask {
    private String format = "html"
    private String style = "docbook"
    private String preprocess = ""
    private String postprocess = ""
    private String returnSecondary = ""
    private String pdf = ""
    private String css = ""
    private String catalogFilename = null;

    DocBookTask() {
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getFormat() {
        format
    }

    def setFormat(String value) {
        format = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getStyle() {
        return style
    }

    def setStyle(String value) {
        style = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getPreprocess() {
        return preprocess
    }

    def setPreprocess(String value) {
        preprocess = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getPostprocess() {
        return postprocess
    }

    def setpostProcess(String value) {
        postprocess = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getReturnSecondary() {
        return returnSecondary
    }

    def setReturnSecondary(String value) {
        returnSecondary = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getPdf() {
        return pdf
    }

    def setPdf(String value) {
        pdf = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getCss() {
        return css
    }

    def setCss(String value) {
        css = value
        return this
    }

    @org.gradle.api.tasks.Input
    @org.gradle.api.tasks.Optional
    String getCatalogFile() {
        return catalogFilename
    }

    def setCatalogFile(String value) {
        catalogFilename = value
        return this
    }

    @Override
    protected void setupRuntime() {
        XSLT20 docbook = new XSLT20()

        File catfile = new File(docbook.createCatalog(catalogFilename));
        String catalog = catfile.toURI().toASCIIString();

        String schemaCatalog = null
        try {
            Class klass = Class.forName("org.docbook.Schemas")
            Object schemas = klass.newInstance()
            Method method = schemas.getClass().getMethod("createCatalog")

            catfile = new File(method.invoke(schemas).toString());
            schemaCatalog = catfile.toURI().toASCIIString();
        } catch (ClassNotFoundException cfne) {
            logger.debug("DocBookTask did not find org.docbook.Schemas class");
        }

        // The options in the build.gradle file are evaluated before we get called.
        // Don't attempt to overwrite anything that's already been set.

        if (pipelineURI == null) {
            pipelineURI = "https://cdn.docbook.org/release/xsl20/current/xslt/base/pipelines/docbook.xpl";
        }

        if (!seenOptions.containsKey("format")) {
            option("format", getFormat())
        }

        if (!seenOptions.containsKey("style")) {
            option("style", getStyle())
        }

        if (!seenOptions.containsKey("preprocess")) {
            option("preprocess", getPreprocess())
        }

        if (!seenOptions.containsKey("postprocess")) {
            option("postprocess", getPostprocess())
        }

        if (!seenOptions.containsKey("return-secondary")) {
            option("return-secondary", getReturnSecondary())
        }

        if (!seenOptions.containsKey("pdf")) {
            option("pdf", getPdf())
        }

        if (!seenOptions.containsKey("css")) {
            option("css", getCss())
        }

        super.setupRuntime()

        if (schemaCatalog != null) {
            logger.debug("DocBookTask adds catalogs to runtime:")
            logger.debug(catalog)
            logger.debug(schemaCatalog)
            runtime.getResolver().addCatalogs([catalog, schemaCatalog])
        } else {
            logger.debug("DocBookTask adds catalog to runtime: " + catalog)
            runtime.getResolver().addCatalogs([catalog])
        }
    }
}
