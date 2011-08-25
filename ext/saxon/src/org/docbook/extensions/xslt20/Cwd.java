package org.docbook.extensions.xslt20;

/**
 * Saxon extension to get Java system properties.
 *
 * <p>Copyright (C) 2011 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://saxon.sourceforge.net/">Saxon</a>
 * extension to return the current working directory (the user.dir system property).</p>
 *
 * <p><b>Change Log:</b></p>
 * <dl>
 * <dt>1.0</dt>
 * <dd><p>Initial release.</p></dd>
 * </dl>
 *
 * @author Norman Walsh
 * <a href="mailto:ndw@nwalsh.com">ndw@nwalsh.com</a>
 */

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.iter.SingletonIterator;
import net.sf.saxon.value.AnyURIValue;
import net.sf.saxon.value.SequenceType;

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
        public SequenceIterator call(SequenceIterator[] arguments, XPathContext context) throws XPathException {
            String dir = System.getProperty("user.dir");
            if (!dir.endsWith("/")) {
                dir += "/";
            }
            return SingletonIterator.makeIterator(new AnyURIValue(dir));
        }
    }
}
