package org.docbook.extensions.xslt20;

import com.nwalsh.annotations.SaxonExtensionFunction;
import net.sf.saxon.expr.StaticProperty;
import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.AtomicArray;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.iter.ArrayIterator;
import net.sf.saxon.type.BuiltInAtomicType;
import net.sf.saxon.value.EmptySequence;
import net.sf.saxon.value.Int64Value;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;

import java.awt.*;
import java.awt.image.ImageObserver;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Saxon extension to obtain the intrinsic size of images.
 *
 * This class provides a
 * <a href="http://saxonica.com/">Saxon</a>
 * extension to find the intrinsic size of images.
 *
 * <p>The function attempts to load the image with the AWT Image toolkit. If that fails,
 * it searches for a bounding box (present in, e.g., EPS and PDF images).
 *
 * <p>If the image can be loaded or a bounding box is found, the width and height
 * of the image are returned.
 *
 * <p>Copyright © 2002-2018 Norman Walsh.</p>
 *
 * @author Norman Walsh
 * <a href="mailto:ndw@nwalsh.com">ndw@nwalsh.com</a>
 */
@SaxonExtensionFunction
public class ImageProperties extends ExtensionFunctionDefinition {
    private static final StructuredQName qName =
            new StructuredQName("", "http://docbook.org/extensions/xslt20", "image-properties");

    private static final Pattern dimPatn = Pattern.compile("^(\\d+(\\.\\d*)?)(.*)$");

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
        return new PropertiesCall();
    }

    private class PropertiesCall extends ExtensionFunctionCall implements ImageObserver {
        boolean imageLoaded = false;
        boolean imageFailed = false;
        Image image = null;
        int width = -1;
        int depth = -1;

        public Sequence call(XPathContext xPathContext, Sequence[] sequences) throws XPathException {
            String imageFn = ((StringValue) sequences[0].head()).getStringValue();

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
                    } else if (line != null
                            && (line.startsWith("<?xml")
                            || line.startsWith("<!DOCTYPE")
                            || line.startsWith("<svg"))) {
                        // We've got an SVG!
                        while (lineLimit > 0 && line != null) {
                            lineLimit--;
                            if (line.contains("width=") && width == -1) {
                                int pos = line.indexOf("width=");
                                String ex = line.substring(pos+7);
                                int sqpos = ex.indexOf("'");
                                int dqpos = ex.indexOf("\"");
                                pos = sqpos < dqpos && sqpos >= 0 ? sqpos : dqpos;
                                width = convertUnits(ex.substring(0, pos));
                            }
                            if (line.contains("height=") && depth == -1) {
                                int pos = line.indexOf("height=");
                                String ex = line.substring(pos+8);
                                int sqpos = ex.indexOf("'");
                                int dqpos = ex.indexOf("\"");
                                pos = sqpos < dqpos && sqpos >= 0 ? sqpos : dqpos;
                                depth = convertUnits(ex.substring(0, pos));
                            }
                            if (width >= 0 && depth >= 0) {
                                lineLimit = 0;
                            }
                            line = ir.readLine();
                        }
                    } else {
                        System.err.println("Failed to interpret image: " + imageFn);
                    }
                } catch (Exception e) {
                    System.err.println("Failed to load image: " + imageFn);
                    width = -1;
                    depth = -1;
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
                ArrayIterator iter = new ArrayIterator(props);
                return new AtomicArray(iter);
            } else {
                return EmptySequence.getInstance();
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

        public int convertUnits(String dim) {
            Matcher matcher = dimPatn.matcher(dim);

            if (matcher.matches()) {
                String magnitude = matcher.group(1);
                String units = matcher.group(3);
                Double d = Double.parseDouble(magnitude);
                d = d * unitsScale(units);
                return d.intValue();
            } else {
                if (dim.matches("^\\d+(\\.\\d*)?$")) {
                    Double d = Double.parseDouble(dim);
                    return d.intValue();
                } else {
                    throw new UnsupportedOperationException("Cannot parse " + dim + " as a dimension");
                }
            }
        }

        public double unitsScale(String units) {
            // N.B. The actual numbers aren't that important because SVG can scale
            if ("pt".equals(units)) {
                return 96.0 / 72.0;
            } else if ("in".equals(units)) {
                return 96.0;
            } else if ("cm".equals(units)) {
                return 96.0 / 2.54;
            } else if ("mm".equals(units)) {
                return 96.0 / 25.4;
            } else if ("px".equals(units)) {
                return 1;
            } else {
                return 1;
            }
        }
    }
}