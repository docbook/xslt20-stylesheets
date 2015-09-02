package org.docbook;


import com.xmlcalabash.core.XProcConfiguration;
import com.xmlcalabash.core.XProcRuntime;
import com.xmlcalabash.io.WritableDocument;
import com.xmlcalabash.model.RuntimeValue;
import com.xmlcalabash.model.Serialization;
import com.xmlcalabash.piperack.Run;
import com.xmlcalabash.runtime.XPipeline;
import com.xmlcalabash.util.Input;
import com.xmlcalabash.util.XProcURIResolver;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XdmNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xmlresolver.Catalog;
import org.xmlresolver.Resolver;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.security.CodeSource;
import java.util.Hashtable;
import java.util.Vector;

class DocBook {
    private static final QName _output = new QName("", "output");

    private String proctype = "he";
    private boolean schemaAware = false;
    private String classLoc = null;
    private Hashtable<String,String> nsbindings = new Hashtable<String, String> ();
    private Hashtable<QName,RuntimeValue> params = new Hashtable<QName, RuntimeValue> ();
    private Vector<String> paramFiles = new Vector<String>();
    private String sourcefn = null;
    private Hashtable<QName,RuntimeValue> options = new Hashtable<QName,RuntimeValue>();
    protected Logger logger = null;

    public DocBook() {
        logger = LoggerFactory.getLogger(DocBook.class);
        // Where am I?
        CodeSource src = DocBook.class.getProtectionDomain().getCodeSource();
        classLoc = src.getLocation().toString();
        logger.debug("classLoc=" + classLoc);
    }

    public void setParam(String param, String value) {
        if (param.contains(":")) {
            int pos = param.indexOf(":");
            String pfx = param.substring(0, pos);
            String local = param.substring(pos+1);
            if (nsbindings.containsKey(pfx)) {
                QName name = new QName(pfx, nsbindings.get(pfx), local);
                params.put(name, new RuntimeValue(value));
                logger.debug("Parameter " + name.getClarkName() + "=" + value);
            } else {
                throw new RuntimeException("No namespace binding for prefix: " + pfx);
            }

        } else {
            params.put(new QName("", param), new RuntimeValue(value));
            logger.debug("Parameter " + param + "=" + value);
        }
    }

    public void setOption(String opt, String value) {
        if (opt.contains(":")) {
            int pos = opt.indexOf(":");
            String pfx = opt.substring(0, pos);
            String local = opt.substring(pos+1);
            if (nsbindings.containsKey(pfx)) {
                QName name = new QName(pfx, nsbindings.get(pfx), local);
                options.put(name, new RuntimeValue(value));
                logger.debug("Option " + name.getClarkName() + "=" + value);
            } else {
                throw new RuntimeException("No namespace binding for prefix: " + pfx);
            }

        } else {
            options.put(new QName("", opt), new RuntimeValue(value));
            logger.debug("Option " + opt + "=" + value);
        }
    }

    public void setNamespace(String prefix, String uri) {
        nsbindings.put(prefix, uri);
    }

    public void addParameterFile(String fn) {
        paramFiles.add(fn);
        logger.debug("Param file=" + fn);
    }

    public void run(String sourcefn) throws IOException, SaxonApiException {
        XProcConfiguration config = new XProcConfiguration(proctype, schemaAware);
        XProcRuntime runtime = new XProcRuntime(config);

        String baseURI = "file://" + System.getProperty("user.dir") + "/";

        XdmNode source = runtime.parse(sourcefn, baseURI);

        String xpl = "/xslt/base/pipelines/docbook.xpl";
        String finalBase = "/xslt/base/";
        if (classLoc.endsWith(".jar")) {
            xpl = "jar:" + classLoc + "!" + xpl;
            finalBase = "jar:" + classLoc + "!" + finalBase;
        } else {
            // This is only supposed to happen on a dev box
            int pos = classLoc.indexOf("/build/");
            xpl = classLoc.substring(0, pos) + xpl;
            finalBase = classLoc.substring(0, pos) + finalBase;
        }

        File tempcat = null;
        try {
            tempcat = File.createTempFile("dbcat", ".xml");
            tempcat.deleteOnExit();
            PrintStream catstream = new PrintStream(tempcat);

            catstream.println("<catalog xmlns='urn:oasis:names:tc:entity:xmlns:xml:catalog'>");

            for (String fn : new String[] { "html/final-pass.xsl", "html/chunktemp.xsl", "fo/final-pass.xsl" }) {
                catstream.println("<uri name='http://docbook.github.com/release/latest/xslt/base/" + fn + "'");
                catstream.println("     uri='" + finalBase + fn + "'/>");
                catstream.println("<uri name='https://docbook.github.io/release/latest/xslt/base/" + fn + "'");
                catstream.println("     uri='" + finalBase + fn + "'/>");

            }

            catstream.println("</catalog>");

            catstream.close();
            logger.debug("Final pass catalog: " + tempcat.getAbsolutePath());
        } catch (IOException ioe) {
            throw new RuntimeException(ioe);
        }

        Catalog catalog = new Catalog(tempcat.getAbsolutePath());

        XProcURIResolver resolver = runtime.getResolver();
        URIResolver uriResolver = resolver.getUnderlyingURIResolver();
        URIResolver myResolver = new DocBookResolver(uriResolver, catalog);
        resolver.setUnderlyingURIResolver(myResolver);

        logger.debug("Pipline=" + xpl);

        XPipeline pipeline = runtime.load(new Input(xpl));
        pipeline.writeTo("source", source);

        for (String param : paramFiles) {
            XdmNode pfile = runtime.parse(param, baseURI);
            pipeline.writeTo("parameters", pfile);
        }

        for (QName param : params.keySet()) {
            pipeline.setParameter(param, params.get(param));
        }

        for (QName opt : options.keySet()) {
            pipeline.passOption(opt, options.get(opt));
        }

        pipeline.run();

        XdmNode result = pipeline.readFrom("result").read();
        Serialization serial = pipeline.getSerialization("result");

        if (serial == null) {
            serial = new Serialization(runtime, pipeline.getNode()); // The node's a hack
            serial.setMethod(new QName("", "xhtml"));
        }

        WritableDocument wd = null;
        if (options.containsKey(_output)) {
            String filename = options.get(_output).getStringValue().asString();
            FileOutputStream outfile = new FileOutputStream(filename);
            wd = new WritableDocument(runtime, filename, serial, outfile);
            logger.info("Writing output to " + filename);
        } else {
            wd = new WritableDocument(runtime, null, serial);
        }

        wd.write(result);
    }


    private class DocBookResolver extends Resolver {
        URIResolver nextResolver = null;
        Resolver resolver = null;

        public DocBookResolver(URIResolver resolver, Catalog catalog) {
            nextResolver = resolver;
            this.resolver = new Resolver(catalog);
        }

        @Override
        public Source resolve(String href, String base) throws TransformerException {
            // We go last
            Source src = nextResolver.resolve(href, base);
            if (src == null) {
                return resolver.resolve(href, base);
            } else {
                return src;
            }
        }
    }
}
