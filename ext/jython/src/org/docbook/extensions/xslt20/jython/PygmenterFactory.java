package org.docbook.extensions.xslt20.jython;

import org.python.core.PyObject;
import org.python.core.PyString;
import org.python.util.PythonInterpreter;

public class PygmenterFactory {
    private PyObject jyPygmenterClass;

    public PygmenterFactory() {
        PythonInterpreter interpreter = new PythonInterpreter();
        interpreter.exec("from DocBookPygmenter import DocBookPygmenter");
        jyPygmenterClass = interpreter.get("DocBookPygmenter");
    }

    public PygmenterType create() {
        PyObject highlightObj = jyPygmenterClass.__call__();
        return (PygmenterType) highlightObj.__tojava__(PygmenterType.class);
    }
}
