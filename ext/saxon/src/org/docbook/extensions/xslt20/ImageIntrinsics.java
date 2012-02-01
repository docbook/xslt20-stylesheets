package org.docbook.extensions.xslt20;

/**
 * Saxon extension to examine intrinsic size of images.
 *
 * <p>Copyright (C) 2002, 2005, 2011 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://saxon.sourceforge.net/">Saxon</a>
 * extension to find the intrinsic size of images.</p>
 *
 * <p><b>Change Log:</b></p>
 * <dl>
 * <dt>2.0</dt>
 * <dd><p>Rewritten to use Saxon 9 ExtensionFunction interfaces.</p></dd>
 * <dt>1.0</dt>
 * <dd><p>Initial release.</p></dd>
 * </dl>
 *
 * @author Norman Walsh
 * <a href="mailto:ndw@nwalsh.com">ndw@nwalsh.com</a>
 */

import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.awt.Toolkit;
import java.awt.Image;
import java.awt.image.ImageObserver;
import java.lang.Thread;
import java.net.URL;
import java.net.MalformedURLException;
import java.util.StringTokenizer;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.expr.StaticProperty;
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

public class ImageIntrinsics extends ExtensionFunctionDefinition {
    private static final StructuredQName qName =
        new StructuredQName("", "http://docbook.org/extensions/xslt20", "image-properties");

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
        return 1;
    }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[]{SequenceType.SINGLE_STRING};
    }

    @Override
    public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
        return SequenceType.makeSequenceType(BuiltInAtomicType.INTEGER, StaticProperty.ALLOWS_ZERO_OR_MORE);
    }

    public ExtensionFunctionCall makeCallExpression() {
        return new IntrinsicsCall();
    }

    private class IntrinsicsCall extends ExtensionFunctionCall implements ImageObserver {
        boolean imageLoaded = false;
        boolean imageFailed = false;
        Image image = null;
        int width = -1;
        int depth = -1;

        public SequenceIterator call(SequenceIterator[] arguments, XPathContext context) throws XPathException {
            String imageFn = ((StringValue) arguments[0].next()).getStringValue();

            imageLoaded = false;
            imageFailed = false;
            image = null;
            width = -1;
            depth = -1;

            System.setProperty("java.awt.headless","true");

            try {
                URL url = new URL(imageFn);
                image = Toolkit.getDefaultToolkit().getImage (url);
            } catch (MalformedURLException mue) {
                image = Toolkit.getDefaultToolkit().getImage (imageFn);
            }

            width = image.getWidth(this);
            depth = image.getHeight(this);

            while (!imageFailed && (width == -1 || depth == -1)) {
                try {
                    java.lang.Thread.currentThread().sleep(50);
                } catch (Exception e) {
                    // nop;
                }
                width = image.getWidth(this);
                depth = image.getHeight(this);
            }

            image.flush();

            if ((width == -1 || depth == -1) && imageFailed) {
                // Maybe it's an EPS or PDF?
                // FIXME: this code is crude
                BufferedReader ir = null;
                String line = null;
                int lineLimit = 100;

                try {
                    ir = new BufferedReader(new FileReader(new File(imageFn)));
                    line = ir.readLine();

                    if (line != null && line.startsWith("%PDF-")) {
                        // We've got a PDF!
                        while (lineLimit > 0 && line != null) {
                            lineLimit--;
                            if (line.startsWith("/CropBox [")) {
                                line = line.substring(10);
                                if (line.indexOf("]") >= 0) {
                                    line = line.substring(0, line.indexOf("]"));
                                }
                                parseBox(line);
                                lineLimit = 0;
                            }
                            line = ir.readLine();
                        }
                    } else if (line != null
                               && line.startsWith("%!")
                               && line.indexOf(" EPSF-") > 0) {
                        // We've got an EPS!
                        while (lineLimit > 0 && line != null) {
                            lineLimit--;
                            if (line.startsWith("%%BoundingBox: ")) {
                                line = line.substring(15);
                                parseBox(line);
                                lineLimit = 0;
                            }
                            line = ir.readLine();
                        }
                    } else {
                        System.err.println("Failed to interpret image: " + imageFn);
                    }
                } catch (Exception e) {
                    System.err.println("Failed to load image: " + imageFn);
                    // nop;
                }

                if (ir != null) {
                    try {
                        ir.close();
                    } catch (Exception e) {
                        // nop;
                    }
                }
            }

            if (width >= 0) {
                Int64Value[] props = { new Int64Value(width), new Int64Value(depth) };
                return new ArrayIterator(props);
            } else {
                return EmptyIterator.getInstance();
            }
        }

        private void parseBox(String line) {
            int [] corners = new int [4];
            int count = 0;

            StringTokenizer st = new StringTokenizer(line);
            while (count < 4 && st.hasMoreTokens()) {
                try {
                    corners[count++] = Integer.parseInt(st.nextToken());
                } catch (Exception e) {
                    // nop;
                }
            }

            width = corners[2] - corners[0];
            depth = corners[3] - corners[1];
        }

        public boolean imageUpdate(Image img, int infoflags,
                                   int x, int y, int width, int height) {
            if (((infoflags & ImageObserver.ERROR) == ImageObserver.ERROR)
                || ((infoflags & ImageObserver.ABORT) == ImageObserver.ABORT)) {
                imageFailed = true;
                return false;
            }

            // I really only care about the width and height, but if I return false as
            // soon as those are available, the BufferedInputStream behind the loader
            // gets closed too early.
            if ((infoflags & ImageObserver.ALLBITS) == ImageObserver.ALLBITS) {
                return false;
            } else {
                return true;
            }
        }
    }
}
