package org.docbook;

import net.sf.saxon.s9api.SaxonApiException;
import org.apache.commons.cli.BasicParser;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

import java.io.IOException;
import java.util.List;

/**
 * Created by ndw on 8/30/15.
 */
public class Main {
    @SuppressWarnings("static-access")
    public static void main(String[] args) throws IOException, SaxonApiException {
        XSLT20 docbook = new XSLT20();
        String usage = "java -jar docbook-xslt2-" + docbook.version() + ".jar [options] dbdoc.xml [param=value [param=value] ...] ";

        // N.B. This is explicitly using Commons-CLI 1.2 because that's the dependency that gradle has
        Options options = new Options();

        Option format = OptionBuilder.withArgName("format").withLongOpt("format").hasArg().withDescription("The format: (x)html (css)print foprint").create("f");
        Option style  = OptionBuilder.withArgName("style").withLongOpt("style").hasArg().withDescription("Custom final-pass XSL stylesheet").create("s");
        Option post   = OptionBuilder.withArgName("postprocess").withLongOpt("postprocess").hasArg().withDescription("Post-processing stylesheet").create();
        Option pdf    = OptionBuilder.withArgName("pdf").withLongOpt("pdf").hasArg().withDescription("Name for the output PDF file (print only)").create();
        Option output = OptionBuilder.withArgName("output").withLongOpt("output").hasArg().withDescription("Name for the output file (defaults to stdout)").create("o");
        Option css    = OptionBuilder.withArgName("css").withLongOpt("css").hasArg().withDescription("A CSS stylesheet (CSS print only)").create();
        Option help   = OptionBuilder.withArgName("help").withLongOpt("help").withDescription("Usage: org.docbook.Main [options] dbdoc.xml").create("h");
        Option params = OptionBuilder.withArgName("params").withLongOpt("params").hasArg().withDescription("A file of parameters").create();
        Option ns     = OptionBuilder.withArgName("namespace").withLongOpt("ns").hasArgs(2).withValueSeparator().withDescription("Namespace binding").create();

        options.addOption(format);
        options.addOption(style);
        options.addOption(post);
        options.addOption(pdf);
        options.addOption(output);
        options.addOption(css);
        options.addOption(params);
        options.addOption(ns);
        options.addOption(help);

        CommandLineParser parser = new BasicParser();
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

            for (String opt : new String[] { "postprocess", "pdf", "css", "output", "format", "style" }) {
                if (cmd.hasOption(opt)) {
                    docbook.setOption(opt, cmd.getOptionValue(opt));
                }
            }

            @SuppressWarnings("unchecked")
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
}
