BUILDDIR = $(top_builddir)/docs

REF_VERSION = $(PYGTKSOURCEVIEW_MAJOR_VERSION).$(PYGTKSOURCEVIEW_MINOR_VERSION)
FULL_VERSION = $(REF_VERSION).$(PYGTKSOURCEVIEW_MICRO_VERSION)

HTML_STYLE = $(PYGOBJECT_DATADIR)/pygobject/xsl/ref-html-style.xsl
PDF_STYLE = $(PYGOBJECT_DATADIR)/pygobject/xsl/pdf-style.xsl

XMLFILES = 							\
	reference/gtksourceview2-ref.xml			\
	reference/gtksourceview2-gtksourceview.xml		\
	reference/gtksourceview2-gtksourcebuffer.xml		\
	reference/gtksourceview2-gtksourcegutter.xml		\
	reference/gtksourceview2-gtksourcelanguage.xml		\
	reference/gtksourceview2-gtksourcelanguagesmanager.xml	\
	reference/gtksourceview2-gtksourcemark.xml		\
	reference/gtksourceview2-gtksourceprintcompositor.xml	\
	reference/gtksourceview2-gtksourcestyle.xml		\
	reference/gtksourceview2-gtksourcestylescheme.xml	\
	reference/gtksourceview2-gtksourcestyleschememanager.xml


HTMLdir = $(datadir)/gtk-doc/html/pygtksourceview2
HTML_DATA =						\
	html/index.html					\
	html/index.sgml					\
	html/class-gtksourcebuffer2.html		\
	html/class-gtksourcegutter2.html			\
	html/class-gtksourcelanguage2.html		\
	html/class-gtksourcelanguagemanager2.html	\
	html/class-gtksourcemark2.html			\
	html/class-gtksourceprintcompositor2.html	\
	html/class-gtksourcestyle2.html			\
	html/class-gtksourcestylescheme2.html		\
	html/class-gtksourcestyleschememanager2.html	\
	html/class-gtksourceview2.html			\
	html/pygtksourceview2.devhelp

CSS_FILES = $(PYGOBJECT_PYGDOCS)/style.css
CSSdir = $(HTMLdir)
CSS_DATA = $(CSS_FILES)

BUILT_SOURCES = 		\
	build_stamp 		\
	reference/builddate.xml	\
	$(HTML_DATA)

CLEANFILES = 			\
	build_stamp 		\
	gtksourceview2-ref.*	\
	reference/builddate.xml	\
	$(HTML_DATA)

EXTRA_DIST = 		\
	$(XMLFILES) 	\
	$(XSLFILES)	\
	$(FIX_XREF)

REFERENCE_DEPS = 	\
	reference 	\
	$(XMLFILES)	\
	$(XSLFILES)

$(HTML_DATA): build_stamp

if ENABLE_DOCS

reference/builddate.xml: $(REFERENCE_DEPS)
	$(PYTHON) -c 'import datetime; print datetime.date.today()' > $@

build_stamp: $(REFERENCE_DEPS)reference/builddate.xml
	xsltproc --nonet --xinclude -o $(BUILDDIR)/html/ \
		 --path $(BUILDDIR)/reference:$(srcdir)/reference \
		 --stringparam gtkdoc.bookname "pygtksourceview2" \
		 --stringparam gtkdoc.version ${REF_VERSION} \
		 $(HTML_STYLE) $(srcdir)/reference/gtksourceview2-ref.xml
	$(PYGOBJECT_FIXXREF) -i $(PYGOBJECT_PYGDOCS) $(BUILDDIR)/html 
	touch $@

pdf: $(REFERENCE_DEPS) reference/builddate.xml
	xsltproc --nonet --xinclude -o gtksourceview2-ref.fo \
		$(PDF_STYLE) reference/gtksourceview2-ref.xml
	pdfxmltex gtksourceview2-ref.fo >output </dev/null
endif
