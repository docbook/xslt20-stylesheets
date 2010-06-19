package net.sf.docbook.saxon;

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

/**
 * Saxon extension to examine intrinsic size of images.
 *
 * <p>$Id: ImageIntrinsics.java 5250 2005-10-12 13:41:40Z nwalsh $</p>
 *
 * <p>Copyright (C) 2002, 2005 Norman Walsh.</p>
 *
 * <p>This class provides a
 * <a href="http://saxon.sourceforge.net/">Saxon</a>
 * extension to find the intrinsic size of images.</p>
 *
 * <p><b>Change Log:</b></p>
 * <dl>
 * <dt>1.0</dt>
 * <dd><p>Initial release.</p></dd>
 * </dl>
 *
 * @author Norman Walsh
 * <a href="mailto:ndw@nwalsh.com">ndw@nwalsh.com</a>
 *
 * @version $Id: ImageIntrinsics.java 5250 2005-10-12 13:41:40Z nwalsh $
 *
 */
public class ImageIntrinsics implements ImageObserver {
  boolean imageLoaded = false;
  boolean imageFailed = false;
  Image image = null;
  int width = -1;
  int depth = -1;

  /**
   * <p>Constructor for ImageIntrinsics.</p>
   */
  public ImageIntrinsics(String imageFn) {
    System.setProperty("java.awt.headless","true");

    try {
	URL url = new URL(imageFn);
	image = Toolkit.getDefaultToolkit().getImage (url);
    } catch (MalformedURLException mue) {
	image = Toolkit.getDefaultToolkit().getImage (imageFn);
    }

    width = image.getWidth(this);

    while (!imageFailed && (width == -1 || depth == -1)) {
      try {
	java.lang.Thread.currentThread().sleep(50);
      } catch (Exception e) {
	// nop;
      }
      width = image.getWidth(this);
      depth = image.getHeight(this);
    }

    if (imageFailed) {
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
  }

  public int[] properties() {
    if (width >= 0) {
      int[] props = new int[2];
      props[0] = width;
      props[1] = depth;
      return props;
    } else {
      return null;
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
    if ((infoflags & ImageObserver.ERROR) == ImageObserver.ERROR) {
      imageFailed = true;
      return false;
    }

    // I really only care about the width and height, but if I return false as
    // soon as those are available, the BufferedInputStream behind the loader
    // gets closed too early.
    int flags = ImageObserver.ALLBITS;
    if ((infoflags & flags) == flags) {
      return false;
    } else {
      return true;
    }
  }
}
