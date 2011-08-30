package org.docbook.extensions.xslt20;

/**
 * Saxon extension to call the Jython DocBook pretty printer.
 *
 * <p>Copyright (C) 2011 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://saxon.sourceforge.net/">Saxon</a>
 * extension to prettyprint source code listings.
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

import net.sf.saxon.Platform;
import net.sf.saxon.Configuration;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.expr.StaticProperty;
import net.sf.saxon.expr.StaticContext;
import net.sf.saxon.expr.Expression;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.value.Int64Value;
import net.sf.saxon.value.StringValue;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.iter.SingletonIterator;
import net.sf.saxon.tree.iter.EmptyIterator;
import net.sf.saxon.tree.iter.ArrayIterator;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.type.BuiltInAtomicType;
import net.sf.saxon.s9api.Axis;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.DocumentBuilder;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmSequenceIterator;
import net.sf.saxon.s9api.SaxonApiException;

import javax.xml.transform.sax.SAXSource;
import java.io.StringReader;
import org.xml.sax.InputSource;

import org.docbook.extensions.xslt20.jython.PygmenterFactory;
import org.docbook.extensions.xslt20.jython.PygmenterType;

public class Pygmenter extends ExtensionFunctionDefinition {
    private static final StructuredQName qName =
        new StructuredQName("", "http://docbook.org/extensions/xslt20", "pretty-print");
    private static final QName h_pre =
        new QName("", "http://www.w3.org/1999/xhtml", "pre");

    private static Processor processor = null;
    private static final PygmenterFactory factory = new PygmenterFactory();

    @Override
    public StructuredQName getFunctionQName() {
        return qName;
    }

    @Override
    public int getMinimumNumberOfArguments() {
        return 1;
    }

    @Override
    public int getMaximumNumberOfArguments() {
        return 2;
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[]{SequenceType.ATOMIC_SEQUENCE};
    }

    @Override
    public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
        return SequenceType.NODE_SEQUENCE;
    }

    public ExtensionFunctionCall makeCallExpression() {
        return new PrettyCall();
    }

    private class PrettyCall extends ExtensionFunctionCall {
        protected StaticContext staticContext = null;

        public void supplyStaticContext(StaticContext context, int locationId,
                                        Expression[] arguments) throws XPathException {
            staticContext = context;
        }

        public void copyLocalData(ExtensionFunctionCall dest) {
            ((PrettyCall) dest).staticContext = staticContext;
        }

        public SequenceIterator call(SequenceIterator[] arguments, XPathContext context) throws XPathException {
            String code = ((StringValue) arguments[0].next()).getPrimitiveStringValue();
            String language = "";

            if (arguments.length > 1) {
                language = ((StringValue) arguments[1].next()).getPrimitiveStringValue();
            }

            if (processor == null) {
                processor = new Processor(context.getConfiguration());
            }

            DocumentBuilder builder = processor.newDocumentBuilder();

            PygmenterType pygmenter = factory.create();
            String result = pygmenter.format(code, language);

            XdmNode doc = null;
            try {
                // Wrap a div with the right namespace around the string
                String parse = "<div xmlns='http://www.w3.org/1999/xhtml'>" + result + "</div>";
                SAXSource source = new SAXSource(new InputSource(new StringReader(parse)));
                doc = builder.build(source);
            } catch (SaxonApiException sae) {
                // I don't ever expect this to happen
                throw new UnsupportedOperationException(sae);
            }

            XdmNode pre = null;
            XdmSequenceIterator preIter = doc.axisIterator(Axis.DESCENDANT, h_pre);
            while (pre == null && preIter.hasNext()) {
                pre = (XdmNode) preIter.next();
            }

            return pre.getUnderlyingNode().iterateAxis(net.sf.saxon.om.Axis.CHILD);
        }
    }
}
