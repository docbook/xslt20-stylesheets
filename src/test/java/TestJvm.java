import org.docbook.XSLT20;

public class TestJvm {
    public static void main(String[] args) {
        XSLT20 docBookXslt = new XSLT20();

        String catalog = docBookXslt.createCatalog();

        // This catalog is a temporary file and will be deleted automatically.
        System.out.println("Temp catalog: " + catalog);

        catalog = docBookXslt.createCatalog("/tmp/dbcat.xml");

        // This catalog is "permanent"; you have to delete it yourself.
        System.out.println("Perm catalog: " + catalog);
    }
}
