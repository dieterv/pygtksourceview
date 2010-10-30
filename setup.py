#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# setup.py - distutils configuration for pygtksourceview


'''Python Bindings for the GtkSourceView library.

PyGtkSourceView is a set of bindings for the GtkSourceView library'''


import os
import sys
import glob

from distutils.command.build import build
from distutils.core import setup


# Check for windows platform
if sys.platform != 'win32':
    msg =  '*' * 68 + '\n'
    msg += '* Building PyGTK using distutils is only supported on windows. *\n'
    msg += '* To build PyGTK in a supported way, read the INSTALL file.    *\n'
    msg += '*' * 68
    raise SystemExit(msg)

# Check for python version
MIN_PYTHON_VERSION = (2, 6, 0)

if sys.version_info[:3] < MIN_PYTHON_VERSION:
    raise SystemExit('ERROR: Python %s or higher is required, %s found.' % (
                         '.'.join(map(str,MIN_PYTHON_VERSION)),
                         '.'.join(map(str,sys.version_info[:3]))))

# Check for pygobject (dsextras)
try:
    from dsextras import GLOBAL_MACROS, GLOBAL_INC, get_m4_define, getoutput, \
                         have_pkgconfig, pkgc_version_check, pkgc_get_defs_dir, \
                         PkgConfigExtension, Template, TemplateExtension, \
                         BuildExt, InstallLib, InstallData
except ImportError:
    raise SystemExit('ERROR: Could not import dsextras module: '
                     'Make sure you have installed pygobject.')

# Check for pkgconfig
if not have_pkgconfig():
    raise SystemExit('ERROR: Could not find pkg-config: '
                     'Please check your PATH environment variable.')


PYGTK_SUFFIX = '2.0'
PYGTK_SUFFIX_LONG = 'gtk-' + PYGTK_SUFFIX
PYGTK_DEFS_DIR = pkgc_get_defs_dir('pygtk-%s' % PYGTK_SUFFIX)

MAJOR_VERSION = int(get_m4_define('pygtksourceview_major_version'))
MINOR_VERSION = int(get_m4_define('pygtksourceview_minor_version'))
MICRO_VERSION = int(get_m4_define('pygtksourceview_micro_version'))
VERSION = '%d.%d.%d' % (MAJOR_VERSION, MINOR_VERSION, MICRO_VERSION)

GTKSOURCEVIEW_REQUIRED = get_m4_define('gtksourceview_required_version')
PYGOBJECT_REQUIRED     = get_m4_define('pygobject_required_version')
PYGTK_REQUIRED         = get_m4_define('pygtk_required_version')

GLOBAL_INC += ['.']
GLOBAL_MACROS += [('PYGTKSOURCEVIEW_MAJOR_VERSION', MAJOR_VERSION),
                  ('PYGTKSOURCEVIEW_MINOR_VERSION', MINOR_VERSION),
                  ('PYGTKSOURCEVIEW_MICRO_VERSION', MICRO_VERSION),
                  ('VERSION', '\\"%s\\"' % VERSION),
                  ('PLATFORM_WIN32', 1),
                  ('HAVE_BIND_TEXTDOMAIN_CODESET', 1)]

HTML_DIR = os.path.join('share', 'gtk-doc', 'html', 'pygtksourceview2')


data_files = []
ext_modules = []


class PyGtkSourceViewInstallData(InstallData):
    def run(self):
        self.add_template_option('VERSION', VERSION)
        self.prepare()

        # Install templates
        self.install_templates()

        InstallData.run(self)

    def install_templates(self):
        self.install_template('pygtksourceview-2.0.pc.in',
                              os.path.join(self.install_dir, 'lib', 'pkgconfig'))

gtksourceview2 = TemplateExtension(name='gtksourceview2',
                                   pkc_name=('pygobject-%s' % PYGTK_SUFFIX,
                                             'pygtk-%s' % PYGTK_SUFFIX,
                                             'gtksourceview-%s' % PYGTK_SUFFIX),
                                   pkc_version=(PYGOBJECT_REQUIRED,
                                                PYGTK_REQUIRED,
                                                GTKSOURCEVIEW_REQUIRED),
                                   defs='gtksourceview2.defs',
                                   register=[os.path.join(PYGTK_DEFS_DIR, 'pango-types.defs').replace('\\', '/'),
                                             os.path.join(PYGTK_DEFS_DIR, 'gdk-types.defs').replace('\\', '/'),
                                             os.path.join(PYGTK_DEFS_DIR, 'gtk-types.defs').replace('\\', '/')],
                                   override='gtksourceview2.override',
                                   sources=['gtksourceview2module.c', 'gtksourceview2.c'],
                                   py_ssize_t_clean=True)

if gtksourceview2.can_build():
    ext_modules.append(gtksourceview2)
    #data_files.append((PYGTK_DEFS_DIR, ('gtksourceview2.defs',)))
    data_files.append((HTML_DIR, glob.glob('docs/html/*.html')))
else:
    raise SystemExit

doclines = __doc__.split('\n')
options = {'bdist_wininst': {'install_script': 'pygtksourceview_postinstall.py'}}

setup(name='pygtksourceview',
      url='http://projects.gnome.org/gtksourceview/pygtksourceview.html',
      version=VERSION,
      license='LGPL',
      platforms=['MS Windows'],
      maintainer='Gian Mario Tagliaretti',
      maintainer_email='gianmt@gnome.org',
      description = doclines[0],
      long_description = '\n'.join(doclines[2:]),
      provides = 'pygtksourceview',
      requires = ['pygobject (>=%s)' % PYGOBJECT_REQUIRED,
                  'pygtk (>=%s)' % PYGTK_REQUIRED],
      ext_modules = ext_modules,
      data_files = data_files,
      scripts = ['pygtksourceview_postinstall.py'],
      options = options,
      cmdclass = {'install_data': PyGtkSourceViewInstallData,
                  'build_ext': BuildExt,})
