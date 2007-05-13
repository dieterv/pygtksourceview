# require automake-1.7
AUTOMAKE_OPTIONS=1.7

SUBDIRS = test

if ENABLE_DOCS
SUBDIRS += docs
endif

INCLUDES = $(PYTHON_INCLUDES)

EXTRA_DIST = gtksourceview2.defs gtksourceview2.override

defsdir = $(datadir)/pygtk/2.0/defs
defs_DATA = gtksourceview2.defs

# pygtksourceview2 module
pyexec_LTLIBRARIES = gtksourceview2module.la
gtksourceview2module_la_LDFLAGS = -module -avoid-version -export-symbols-regex initgtksourceview2
gtksourceview2module_la_CFLAGS = $(PYGTKSOURCEVIEW2_CFLAGS)
gtksourceview2module_la_LIBADD = $(PYGTKSOURCEVIEW2_LIBS)
gtksourceview2module_la_SOURCES = gtksourceview2module.c 
nodist_gtksourceview2module_la_SOURCES = gtksourceview2.c
gtksourceview2.c: gtksourceview2.defs gtksourceview2.override
CLEANFILES = pygtksourceview2.c

.defs.c:
	(cd $(srcdir)\
	&& $(PYTHON) $(CODEGEN) \
		--override $*.override \
	    --register @PYGTK_DATADIR@/pygtk/2.0/defs/gdk-types.defs \
	    --register @PYGTK_DATADIR@/pygtk/2.0/defs/pango-types.defs \
	    --register @PYGTK_DATADIR@/pygtk/2.0/defs/gtk-types.defs \
		--prefix py$* $*.defs) > gen-$*.c \
	    && cp gen-$*.c $*.c \
	    && rm -f gen-$*.c
