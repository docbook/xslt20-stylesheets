package org.docbook;


import com.xmlcalabash.core.XProcConfiguration;
import com.xmlcalabash.core.XProcRuntime;
import com.xmlcalabash.io.WritableDocument;
import com.xmlcalabash.model.RuntimeValue;
import com.xmlcalabash.model.Serialization;
import com.xmlcalabash.runtime.XPipeline;
import com.xmlcalabash.util.Input;
import com.xmlcalabash.util.XProcURIResolver;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.ValidationMode;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmDestination;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;
import org.xmlresolver.Catalog;
import org.xmlresolver.Resolver;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.security.CodeSource;
import java.util.Hashtable;
import java.util.Properties;
import java.util.Vector;

class DocBook {
    private static final QName _output = new QName("", "output");
    private static final QName _format = new QName("", "format");

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

        String jarloc = "";
        if (classLoc.endsWith(".jar")) {
            jarloc = "jar:" + classLoc + "!";
        } else {
            // This is only supposed to happen on a dev box
            int pos = classLoc.indexOf("/build/");
            jarloc = classLoc.substring(0, pos);
        }

        String format = "html";
        if (options.containsKey(_format)) {
            format = options.get(_format).getString();
        }

        String xpl = "db2html.xpl";
        if (format.equals("foprint") || format.equals("cssprint")) {
            xpl = "db2pdf.xpl";
        } else if (format.equals("xhtml")) {
            xpl = "db2xhtml.xpl";
        } else if (format.equals("fo")) {
            xpl = "db2fo.xpl";
        }

        xpl = jarloc + "/xslt/base/pipelines/" + xpl;

        XdmNode xcat = runtime.parse(new InputSource(getClass().getResourceAsStream("/etc/uris.xml")));
        XdmNode patch = runtime.parse(new InputSource(getClass().getResourceAsStream("/etc/make-catalog.xsl")));

        XsltCompiler compiler = runtime.getProcessor().newXsltCompiler();
        compiler.setSchemaAware(false);
        XsltExecutable exec = compiler.compile(patch.asSource());
        XsltTransformer transformer = exec.load();

        transformer.setParameter(new QName("", "jarloc"), new XdmAtomicValue(jarloc));
        transformer.setParameter(new QName("", "version"), new XdmAtomicValue(version()));

        transformer.setInitialContextNode(xcat);

        XdmDestination xresult = new XdmDestination();
        transformer.setDestination(xresult);

        transformer.setSchemaValidationMode(ValidationMode.DEFAULT);
        transformer.transform();
        XdmNode xformed = xresult.getXdmNode();

        //File tempcat = new File("/tmp/dbcat.xml");
        File tempcat = File.createTempFile("dbcat", ".xml");
        tempcat.deleteOnExit();

        PrintStream catstream = new PrintStream(tempcat);
        catstream.print(xformed.toString());
        catstream.close();

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
        if (result != null) {
            Serialization serial = pipeline.getSerialization("result");

            if (serial == null) {
                serial = new Serialization(runtime, pipeline.getNode()); // The node's a hack
                serial.setMethod(new QName("", "xhtml"));
            }

            WritableDocument wd = null;
            if (options.containsKey(_output)) {
                String filename = options.get(_output).getStringValue().getPrimitiveStringValue().toString();
                FileOutputStream outfile = new FileOutputStream(filename);
                wd = new WritableDocument(runtime, filename, serial, outfile);
                logger.info("Writing output to " + filename);
            } else {
                wd = new WritableDocument(runtime, null, serial);
            }

            wd.write(result);
        }
    }

    public String version() {
        Properties config = new Properties();
        InputStream stream = null;
        try {
            stream = Main.class.getResourceAsStream("/etc/version.properties");
            if (stream == null) {
                throw new UnsupportedOperationException("JAR file doesn't contain version.properties file!?");
            }
            config.load(stream);
            String version = config.getProperty("version");
            if (version == null) {
                throw new UnsupportedOperationException("Invalid version.properties in JAR file!?");
            }
            return version;
        } catch (IOException ioe) {
            throw new UnsupportedOperationException("No version.properties in JAR file!?");
        }
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
