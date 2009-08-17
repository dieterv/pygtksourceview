# require automake-1.9
AUTOMAKE_OPTIONS=1.9

SUBDIRS = test

if ENABLE_DOCS
SUBDIRS += docs
endif

INCLUDES = $(PYTHON_INCLUDES)

EXTRA_DIST =				\
	gtksourceview2.defs		\
	gtksourceview2.override		\
	pygtksourceview-2.0.pc.in	\
	ChangeLog-pre-git

BUILT_EXTRA_DIST = ChangeLog

defsdir = $(datadir)/pygtk/2.0/defs
defs_DATA = gtksourceview2.defs

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = pygtksourceview-2.0.pc

if PLATFORM_WIN32
no_undefined = -no-undefined
endif
if OS_WIN32
pyd_ext = -shrext ".pyd"
endif

# pygtksourceview2 module
pyexec_LTLIBRARIES = gtksourceview2.la
gtksourceview2_la_LDFLAGS = -module -avoid-version -export-symbols-regex initgtksourceview2 $(no_undefined) $(pyd_ext)
gtksourceview2_la_CFLAGS = $(PYGTKSOURCEVIEW_CFLAGS)
gtksourceview2_la_LIBADD = $(PYGTKSOURCEVIEW_LIBS) $(PYTHON_LIBS)
gtksourceview2_la_SOURCES = gtksourceview2module.c pygtksourceview-private.h
nodist_gtksourceview2_la_SOURCES = gtksourceview2.c
gtksourceview2.c: gtksourceview2.defs gtksourceview2.override
CLEANFILES = gtksourceview2.c

.defs.c:
	(cd $(srcdir)\
	&& $(PYTHON) $(CODEGEN)							\
		--override $*.override						\
		--register @PYGTK_DATADIR@/pygtk/2.0/defs/gdk-types.defs	\
		--register @PYGTK_DATADIR@/pygtk/2.0/defs/pango-types.defs	\
		--register @PYGTK_DATADIR@/pygtk/2.0/defs/gtk-types.defs	\
		--prefix py$* $*.defs) > gen-$*.c				\
		&& cp gen-$*.c $*.c						\
		&& rm -f gen-$*.c

.PHONY: ChangeLog

ChangeLog:
	@echo Creating $@
	@if test -d "$(srcdir)/.git"; then \
		(GIT_DIR=$(top_srcdir)/.git ./missing --run git log PYGTKSOURCEVIEW_2_6_0^^.. --stat) | fmt --split-only > $@.tmp \
		&& mv -f $@.tmp $@ \
		|| ($(RM) $@.tmp; \
		echo Failed to generate ChangeLog, your ChangeLog may be outdated >&2; \
		(test -f $@ || echo git-log is required to generate this file >> $@)); \
	else \
		test -f $@ || \
		(echo A git checkout and git-log is required to generate ChangeLog >&2 && \
		echo A git checkout and git-log is required to generate this file >> $@); \
	fi


distclean-local:
	if test $(srcdir) = .; then :; else \
		rm -f $(BUILT_EXTRA_DIST); \
	fi

dist-hook: $(BUILT_EXTRA_DIST)
	files='$(BUILT_EXTRA_DIST)'; \
	for f in $$files; do \
		if test -f $$f; then d=.; else d=$(srcdir); fi; \
		rm -f $(distdir)/$$f && cp $$d/$$f $(distdir) || exit 1; done
