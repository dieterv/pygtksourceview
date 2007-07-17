dnl a macro to check for ability to create python extensions
dnl  AM_CHECK_PYTHON_HEADERS([ACTION-IF-POSSIBLE], [ACTION-IF-NOT-POSSIBLE])
dnl function also defines PYTHON_INCLUDES
AC_DEFUN([AM_CHECK_PYTHON_HEADERS],
[AC_REQUIRE([AM_PATH_PYTHON])
AC_MSG_CHECKING(for headers required to compile python extensions)
dnl deduce PYTHON_INCLUDES
py_prefix=`$PYTHON -c "import sys; print sys.prefix"`
py_exec_prefix=`$PYTHON -c "import sys; print sys.exec_prefix"`
PYTHON_INCLUDES="-I${py_prefix}/include/python${PYTHON_VERSION}"
if test "$py_prefix" != "$py_exec_prefix"; then
  PYTHON_INCLUDES="$PYTHON_INCLUDES -I${py_exec_prefix}/include/python${PYTHON_VERSION}"
fi
AC_SUBST(PYTHON_INCLUDES)
dnl check if the headers exist:
save_CPPFLAGS="$CPPFLAGS"
CPPFLAGS="$CPPFLAGS $PYTHON_INCLUDES"
AC_TRY_CPP([#include <Python.h>],dnl
[AC_MSG_RESULT(found)
$1],dnl
[AC_MSG_RESULT(not found)
$2])
CPPFLAGS="$save_CPPFLAGS"
])

dnl
dnl JH_ADD_CFLAG(FLAG)
dnl checks whether the C compiler supports the given flag, and if so, adds
dnl it to $CFLAGS.  If the flag is already present in the list, then the
dnl check is not performed.
AC_DEFUN([JH_ADD_CFLAG],
[
case " $CFLAGS " in
*@<:@\	\ @:>@$1@<:@\	\ @:>@*)
  ;;
*)
  save_CFLAGS="$CFLAGS"
  CFLAGS="$CFLAGS $1"
  AC_MSG_CHECKING([whether [$]CC understands $1])
  AC_TRY_COMPILE([], [], [jh_has_option=yes], [jh_has_option=no])
  AC_MSG_RESULT($jh_has_option)
  if test $jh_has_option = no; then
    CFLAGS="$save_CFLAGS"
  fi
  ;;
esac])


dnl ------------------------------------------------------------------------
dnl MOO_AM_PYTHON_DEVEL_CROSS_MINGW([action-if-found[,action-if-not-found]])
dnl
AC_DEFUN([MOO_AM_PYTHON_DEVEL_CROSS_MINGW],[
  AC_REQUIRE([LT_AC_PROG_SED]) dnl to get $SED set

  if test "x$PYTHON_HOME" = x; then
    AC_MSG_ERROR([PYTHON_HOME environment variable must be set dnl
		  when cross-compiling with mingw])
  fi

  AC_MSG_CHECKING(host system python version)
  if test "x$PYTHON_VERSION" = x; then
    # guess python version, very clever heuristics here
    for _ac_python_minor in 3 4 5 6 7 8 9; do
      if test -f "$PYTHON_HOME/libs/libpython2$_ac_python_minor.a" -o \
      	-f "$PYTHON_HOME/libs/python2$_ac_python_minor.lib" ;
      then
        _ac_pyversion="2.$_ac_python_minor"
        break
      fi
    done
  else
    _ac_pyversion=$PYTHON_VERSION
  fi
  if test "x$_ac_pyversion" = x; then
    AC_MSG_ERROR([Could not determine Python version])
  fi
  AC_MSG_RESULT([$_ac_pyversion])
  _ac_pyversion_no_dot=`echo $_ac_pyversion | $SED 's/^2\.*\([[3-9]]\).*/2\1/'`

  AC_MSG_CHECKING(installation directory for python modules)
  if test "x$PYTHON_PKG_DIR" != x; then
    _ac_pythondir=$PYTHON_PKG_DIR
  else
    _ac_pythondir="$PYTHON_HOME/Lib/site-packages"
  fi
  AC_MSG_RESULT([$_ac_pythondir])

  if test "x$PYTHON_INCLUDES" != x; then
    _ac_pyincludes=$PYTHON_INCLUDES
  else
    _ac_pyincludes="-I$PYTHON_HOME/include"
  fi

  if test "x$PYTHON_LIBS" != x; then
    _ac_pylibs=$PYTHON_LIBS
  else
    _ac_pylibs="-L$PYTHON_HOME/libs -lpython$_ac_pyversion_no_dot"
  fi

  if test "x$PYTHON_LDFLAGS" != x; then
    _ac_pyldflags=$PYTHON_LDFLAGS
  else
    _ac_pyldflags=
  fi

  _ac_have_pydev=false
  _ac_save_CPPFLAGS="$CPPFLAGS"
  _ac_save_LDFLAGS="$LDFLAGS"
  _ac_save_LIBS="$LIBS"
  CPPFLAGS="$CPPFLAGS $_ac_pyincludes"
  LDFLAGS="$LDFLAGS $_ac_pyldflags"
  LIBS="$LIBS $_ac_pylibs"
  AC_MSG_CHECKING(python headers and linker flags)
  AC_TRY_LINK([#include <Python.h>],[Py_Initialize();],[
    AC_MSG_RESULT([$_ac_pyincludes $_ac_pyldflags $_ac_pylibs])
    _ac_have_pydev=true
  ],[
    AC_MSG_RESULT(not found)
  ])
  CPPFLAGS="$_ac_save_CPPFLAGS"
  LDFLAGS="$_ac_save_LDFLAGS"
  LIBS="$_ac_save_LIBS"

  if $_ac_have_pydev; then
    AC_SUBST(PYTHON_PLATFORM, [nt])
    AC_SUBST(PYTHON_INCLUDES,[$_ac_pyincludes])
    AC_SUBST(PYTHON_LIBS,[$_ac_pylibs])
    AC_SUBST(PYTHON_EXTRA_LIBS,[])
    AC_SUBST(PYTHON_LDFLAGS,[$_ac_pyldflags])
    AC_SUBST(PYTHON_EXTRA_LDFLAGS,[])
    AC_SUBST(pythondir,[$_ac_pythondir])
    AC_SUBST(pyexecdir,[$_ac_pythondir])
    AC_SUBST(pkgpythondir,[\${pythondir}/$PACKAGE])
    AC_SUBST(pkgpyexecdir,[\${pythondir}/$PACKAGE])
    m4_if([$1],[],[:],[$1])
  else
    m4_if([$2],[],[:],[$2])
  fi
])
dnl
dnl end of MOO_AM_PYTHON_DEVEL_CROSS_MINGW
dnl --------------------------------------
