package org.docbook

import com.xmlcalabash.drivers.Main
import com.xmlcalabash.util.ParseArgs
import com.xmlcalabash.util.UserArgs
import org.gradle.api.internal.ConventionTask
import org.gradle.api.tasks.Input;
import org.gradle.api.tasks.TaskAction

import com.xmlcalabash.core.XProcConfiguration;
import com.xmlcalabash.core.XProcRuntime;
import com.xmlcalabash.model.RuntimeValue;
import com.xmlcalabash.runtime.XPipeline;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.XdmNode;

class DocBookTask extends ConventionTask {
    private Hashtable<String,String> nsBindings = new Hashtable<String,String> ()
    private Hashtable<String,String> params = new Hashtable<String,String> ()
    private Hashtable<String,String> options = new Hashtable<String,String> ()
    private Vector<String> extensions = new Vector<String> ()

    private String paramFile = null
    private String input = null
    private String output = null

    DocBookTask() {
    }

    private String getOpt(String optName) {
        if (options.containsKey(optName)) {
            return options.get(optName)
        } else {
            return null
        }
    }

    String getFormat() {
        return getOpt("format")
    }

    def setFormat(String format) {
        options.put("format", format)
        return this
    }

    String getStyle() {
        return getOpt("style")
    }

    def setStyle(String style) {
        options.put("style", style)
        return this
    }

    String getPreprocess() {
        return getOpt("preprocess")
    }

    def setPreprocess(String preprocess) {
        options.put("preprocess", preprocess)
        return this
    }

    String getPostprocess() {
        return getOpt("postprocess")
    }

    def setpostProcess(String postprocess) {
        options.put("postprocess", postprocess)
        return this
    }

    String getReturnSecondary() {
        return getOpt("return-secondary")
    }

    def setReturnSecondary(String returnSecondary) {
        options.put("return-secondary", returnSecondary)
        return this
    }

    String getPdf() {
        return getOpt("pdf")
    }

    def setPdf(String pdf) {
        options.put("pdf", pdf)
        return this
    }

    String getCss() {
        return getOpt("css")
    }

    def setCss(String css) {
        options.put("css", css)
        return this
    }

    String getParamFile() {
        return paramFile
    }

    def setParamFile(String paramFile) {
        this.paramFile = paramFile
        return this
    }

    @Input
    String getInput() {
        return input
    }

    def setInput(String input) {
        this.input = input
        return this
    }

    String getOutput() {
        return output
    }

    def setOutput(String output) {
        this.output = output
        return this
    }

    void namespaceBinding(String prefix, String uri) {
        nsBindings.put(prefix,uri)
    }

    String param(String qname, String value) {
        params.put(qname, value)
    }

    List getCalabashExtensions() {
        return extensions
    }

    def setCalabashExtensions(Iterable<String> extensions) {
        this.extensions.clear()
        for (String s : extensions) {
            this.extensions.add(s)
        }
        return this
    }

    def setCalabashExtensions(String... extensions) {
        this.extensions.clear()
        for (String s : extensions) {
            this.extensions.add(s)
        }
        return this
    }

    @TaskAction
    void exec() {
        DocBook docbook = new DocBook()

        for (String ns : nsBindings.keySet()) {
            docbook.setNamespace(ns, nsBindings.get(ns))
        }

        for (String param : params.keySet()) {
            docbook.setParam(param, params.get(param))
        }

        for (String opt : options.keySet()) {
            docbook.setOption(opt, options.get(opt))
        }

        if (paramFile != null) {
            docbook.addParameterFile(paramFile)
        }

        if (output != null) {
            docbook.setOption("output", output)
        }

        if (input == null) {
            throw notAllowed("You must specify the input file")
        }

        docbook.run(input)
    }

    private static UnsupportedOperationException notAllowed(final String msg) {
        return new UnsupportedOperationException (msg)
    }

}
