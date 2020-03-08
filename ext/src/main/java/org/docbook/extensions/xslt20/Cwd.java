package org.docbook.extensions.xslt20;


import com.nwalsh.annotations.SaxonExtensionFunction;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.AnyURIValue;
import net.sf.saxon.value.SequenceType;

/**
 * Saxon extension to get the current working directory.
 *
 * This class provides a
 * <a href="http://saxonica.com/">Saxon</a>
 * extension to return the current working directory (the user.dir system property).
 *
 * <p>Copyright © 2011-2018 Norman Walsh.
 *
 * @author Norman Walsh
 * <a href="mailto:ndw@nwalsh.com">ndw@nwalsh.com</a>
 */
@SaxonExtensionFunction
public class Cwd extends ExtensionFunctionDefinition {
    private static final StructuredQName qName =
            new StructuredQName("", "http://docbook.org/extensions/xslt20", "cwd");

    @Override
    public StructuredQName getFunctionQName() {
        return qName;
    }

    @Override
    public int getMinimumNumberOfArguments() {
        return 0;
    }

    @Override
    public int getMaximumNumberOfArguments() {
        return 0;
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        // If it takes no arguments, what's this for?
        return new SequenceType[]{SequenceType.OPTIONAL_NUMERIC};
    }

    @Override
    public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
        return SequenceType.SINGLE_ATOMIC;
    }

    public ExtensionFunctionCall makeCallExpression() {
        return new CwdCall();
    }

    private class CwdCall extends ExtensionFunctionCall {
        public Sequence call(XPathContext xPathContext, Sequence[] sequences) throws XPathException {
            String dir = System.getProperty("user.dir");
            if (!dir.endsWith("/")) {
                dir += "/";
            }
            return new AnyURIValue(dir);
        }
    }
}