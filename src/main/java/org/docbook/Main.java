package org.docbook;

import net.sf.saxon.s9api.SaxonApiException;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import java.io.IOException;
import java.io.InputStream;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;

/**
 * Created by ndw on 8/30/15.
 */
public class Main {
    private static final String usage = "java -jar docbook-xslt2-" + version() + ".jar [options] dbdoc.xml [param=value [param=value] ...] ";

    public static void main(String[] args) throws IOException, SaxonApiException {
        DocBook docbook = new DocBook();

        Options options = new Options();

        Option format = Option.builder("f").argName("format").longOpt("format").hasArg().desc("The format: (x)html (css)print foprint").build();
        Option style  = Option.builder("s").argName("stylesheet").longOpt("stylesheet").hasArg().desc("Custom final-pass XSL stylesheet").build();
        Option post   = Option.builder().argName("postprocess").longOpt("postprocess").hasArg().desc("Post-processing stylesheet").build();
        Option pdf    = Option.builder().argName("pdf").longOpt("pdf").hasArg().desc("Name for the output PDF file (print only)").build();
        Option output = Option.builder("o").argName("output").longOpt("output").hasArg().desc("Name for the output file (defaults to stdout)").build();
        Option css    = Option.builder().argName("css").longOpt("css").hasArg().desc("A CSS stylesheet (CSS print only)").build();

        Option help   = Option.builder("h").argName("help").longOpt("help").desc("Usage: org.docbook.Main [options] dbdoc.xml").build();
        Option params = Option.builder().argName("params").longOpt("params").hasArg().desc("A file of parameters").build();
        Option ns     = Option.builder().argName("namespace").longOpt("ns").hasArgs().numberOfArgs(2).valueSeparator().desc("Namespace binding").build();

        options.addOption(format);
        options.addOption(style);
        options.addOption(post);
        options.addOption(pdf);
        options.addOption(output);
        options.addOption(css);
        options.addOption(params);
        options.addOption(ns);
        options.addOption(help);

        CommandLineParser parser = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();

        try {
            CommandLine cmd = parser.parse(options, args);

            if (cmd.hasOption("ns")) {
                String[] nsbindings = cmd.getOptionValues("ns");
                for (int idx = 0; idx < nsbindings.length; idx += 2) {
                    String pfx = nsbindings[idx];
                    String uri = nsbindings[idx + 1];
                    docbook.setNamespace(pfx,uri);
                }
            }

            if (cmd.hasOption("params")) {
                for (String paramfn : cmd.getOptionValues("params")) {
                    docbook.addParameterFile(paramfn);
                }
            }

            for (String opt : new String[] { "postprocess", "pdf", "css", "output", "format", "stylesheet" }) {
                if (cmd.hasOption(opt)) {
                    docbook.setOption(opt, cmd.getOptionValue(opt));
                }
            }

            List<String> rest = cmd.getArgList();
            String doc = null;

            for (String param : rest) {
                if (param.contains("=")) {
                    int pos = param.indexOf("=");
                    String name = param.substring(0, pos);
                    String value = param.substring(pos+1);
                    docbook.setParam(name, value);
                } else {
                    doc = param;
                }
            }

            if (doc == null) {
                formatter.printHelp(usage, options);
                System.exit(1);
            }

            docbook.run(doc);
        } catch (ParseException pe) {
            System.err.println("Unexpected: " + pe.getMessage());
            formatter.printHelp(usage, options);
            System.exit(1);
        }
    }

    private static String version() {
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
}
