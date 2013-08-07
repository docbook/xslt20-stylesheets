$Id: INSTALL 5204 2005-10-03 06:40:42Z xmldoc $

# How to Install the DocBook XSL2 distribution


## Case 1: Standard Installation

If you have installed the DocBook XSL2 distribution using `apt-get`, `yum`, `urpmi`, 
or some similar package-management front-end, then you're already set. 
As part of the package installation, the  stylesheets have already been 
automatically installed in the appropriate location for your system, and 
your XML catalog environment has (probably) been updated to use that location.


## Case 2: Manual Installation

If you have downloaded a `docbook-xsl2.zip`, `.tar.gz`, or `.tar.bz2`
file, use the following steps to install it.


### Required Steps

1. **Move the `.zip`, `.tar.gz`, or `.tar.bz2` file to the directory where you'd like to install it.** <br>
   Don't use a temporary directory.

2. **unzip or untar/uncompress the file.** <br>
   This will create a `docbook-xsl2-$VERSION` directory (where `$VERSION` is the release's version number).


### Optional: Update XML Catalog

The remaining steps are all **optional**. You're **not required** to complete these remaining steps. 

If you want to use XML Catalogs with DocBook XSL2, completing these steps will automatically 
update your user environment with XML Catalog information about the DocBook XSL2 distribution.  

Otherwise, you'll need to manually update your XML catalog environment to use XML Catalogs with DocBook XSL2.


3. In the `docbook-xsl2-$VERSION` directory, execute the `install.sh` script:

    ./install.sh

  That will launch an interactive installer, which will emit a series of prompts 
  for you to respond to. 
  
  After the process is complete, the installer will print a command you must run 
  in order to source your environment for use with the stylesheets.

4. To test that he installation has updated your environment
   correctly, execute the `test.sh` script:

    ./test.sh

   This tests your XML catalog environment (using both the `xmlcatalog` application and the 
   Apache XML Commons Resolver).

   **NOTE:** The `test.sh` file isn't created until `install.sh` is run for the first time. 
   You must run `install.sh` before running `test.sh`.


# Uninstalling 

If you want to uninstall the release, run the `uninstall.sh` script.

    ./uninstall.sh

This will revert all changes made by the `install.sh` script.

**NOTE:** The `uninstall.sh` file isn't created until `install.sh` is run for the first time. 
You must run `install.sh` before running `uninstall.sh`.

----

# Note to packagers

The following files **should not** be packaged; they're only useful for manual installation:

- `install.sh`
- `.CatalogManager.properties.example`
- `.urilist`

The `catalog.xml` file **should** be packaged.
