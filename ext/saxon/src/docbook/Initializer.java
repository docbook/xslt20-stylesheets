package docbook;

/**
 * Saxon intializer to allow Saxon HE to load DocBook extension functions
 *
 * <p>Copyright (C) 2011 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://saxon.sourceforge.net/">Saxon</a>
 * Initializer to establish the DocBook extension functions.
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

import net.sf.saxon.Configuration;
import net.sf.saxon.trans.XPathException;
import org.docbook.extensions.xslt20.Cwd;
import org.docbook.extensions.xslt20.ImageIntrinsics;
import org.docbook.extensions.xslt20.Pygmenter;

public class Initializer implements net.sf.saxon.lib.Initializer {

    public void initialize(Configuration config) {
        try {
            config.registerExtensionFunction(new Cwd());
            config.registerExtensionFunction(new ImageIntrinsics());

            try {
                config.registerExtensionFunction(new Pygmenter());
            } catch (NoClassDefFoundError ncdfe) {
                // Jython must not be on the classpath.
                // That's ok, just ignore this extension function.
            }
        } catch (XPathException xe) {
            System.err.println("Failed to register DocBook extension functions:");
            xe.printStackTrace();
        }
    }
}
