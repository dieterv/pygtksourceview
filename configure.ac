AC_PREREQ(2.52)

dnl the pygtksourceview version number
m4_define(pygtksourceview_major_version, 2)
m4_define(pygtksourceview_minor_version, 10)
m4_define(pygtksourceview_micro_version, 1)
m4_define(pygtksourceview_version, pygtksourceview_major_version.pygtksourceview_minor_version.pygtksourceview_micro_version)

dnl versions of packages we require ...
m4_define(pygobject_required_version, 2.15.2)
m4_define(pygtk_required_version, 2.8.0)
m4_define(gtksourceview_required_version, 2.9.7)

AC_INIT([pygtksourceview], [pygtksourceview_version], [http://bugzilla.gnome.org/browse.cgi?product=gtksourceview/])

AC_DEFINE(PYGTKSOURCEVIEW_MAJOR_VERSION, pygtksourceview_major_version, [PyGtksourceview major version])
AC_DEFINE(PYGTKSOURCEVIEW_MINOR_VERSION, pygtksourceview_minor_version, [PyGtksourceview minor version])
AC_DEFINE(PYGTKSOURCEVIEW_MICRO_VERSION, pygtksourceview_micro_version, [PyGtksourceview macro version])

AC_CONFIG_SRCDIR([./gtksourceview2module.c])
AM_CONFIG_HEADER(config.h)

AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)

dnl put the ACLOCAL flags in the makefile
ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_MSG_CHECKING([for some Win32 platform])
case "$host" in
  *-*-mingw*|*-*-cygwin*)
    platform_win32=yes
    ;;
  *)
    platform_win32=no
    ;;
esac
AC_MSG_RESULT([$platform_win32])
AM_CONDITIONAL(PLATFORM_WIN32, test "$platform_win32" = "yes")

AC_MSG_CHECKING([for native Win32])
case "$host" in
  *-*-mingw*)
    os_win32=yes
    ;;
  *)
    os_win32=no
    ;;
esac
AC_MSG_RESULT([$os_win32])
AM_CONDITIONAL(OS_WIN32, test "$os_win32" = "yes")

AC_DISABLE_STATIC
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL

dnl when using libtool 2.x create libtool early, because it's used in configure
m4_ifdef([LT_OUTPUT], [LT_OUTPUT])

if test "x$os_win32" = xyes -a "x$cross_compiling" = xyes; then
MOO_AM_PYTHON_DEVEL_CROSS_MINGW(,[AC_MSG_ERROR(could not find Python headers)])
else
AM_PATH_PYTHON(2.2)
AM_CHECK_PYTHON_HEADERS(,[AC_MSG_ERROR(could not find Python headers)])
fi

dnl check pygobject path for docs xsl
PKG_CHECK_MODULES(PYGOBJECT, [pygobject-2.0 >= pygobject_required_version])

PYGOBJECT_INCLUDEDIR=`$PKG_CONFIG --variable=pygtkincludedir pygobject-2.0`
AC_SUBST(PYGOBJECT_INCLUDEDIR)

PYGOBJECT_DATADIR=`$PKG_CONFIG --variable=datadir pygobject-2.0`
AC_SUBST(PYGOBJECT_DATADIR)

PYGOBJECT_FIXXREF="$PYTHON `$PKG_CONFIG --variable=fixxref pygobject-2.0`"
AC_SUBST(PYGOBJECT_FIXXREF)

PYGOBJECT_PYGDOCS="`$PKG_CONFIG --variable=pygdocs pygobject-2.0`"
AC_SUBST(PYGOBJECT_PYGDOCS)

dnl Building documentation
AC_ARG_ENABLE(docs,
  AC_HELP_STRING([--disable-docs], [Disable documentation building]),,
  enable_docs=yes)
if test "${enable_docs}" != no; then
  dnl Check for xsltproc
  AC_PATH_PROG([XSLTPROC], [xsltproc])
  if test -z "$XSLTPROC"; then
    enable_docs=no
  fi
fi

if test x$enable_docs = xyes; then
   if ! $PKG_CONFIG "pygobject-2.0 >= 2.11.3"; then
       AC_MSG_WARN([pygobject-2.0 < 2.11.3; disabling generation of docs])
       enable_docs=no
   fi
fi

AM_CONDITIONAL(ENABLE_DOCS, test x$enable_docs != xno)

dnl get rid of the -export-dynamic stuff from the configure flags ...
export_dynamic=`(./libtool --config; echo eval echo \\$export_dynamic_flag_spec) | sh`

dnl pygtk
PKG_CHECK_MODULES(PYGTKSOURCEVIEW, [
                  pygtk-2.0 >= pygtk_required_version
                  gtksourceview-2.0 >= gtksourceview_required_version
                  ])
PYGTK_DATADIR=`$PKG_CONFIG --variable=datadir pygtk-2.0`

AC_SUBST(PYGTK_DATADIR)


dnl codegen
AC_MSG_CHECKING(for pygtk codegen)
CODEGENDIR=`$PKG_CONFIG --variable=codegendir pygtk-2.0`
echo $CODEGENDIR
if test -f $CODEGENDIR/codegen.py; then
	CODEGEN=$CODEGENDIR/codegen.py
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
	AC_MSG_ERROR([Error: codegen not found (should be shipped with pygtk!)])
fi
AC_SUBST(CODEGEN)

JH_ADD_CFLAG([-Wall])
JH_ADD_CFLAG([-fno-strict-aliasing])

dnl output
AC_CONFIG_FILES(
  Makefile
  pygtksourceview-2.0.pc
  test/Makefile
  docs/Makefile
  docs/reference/entities.docbook
)

GTK_DOC_CHECK(1.4)

AC_OUTPUT
