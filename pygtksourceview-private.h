/* PyGtkSourceView2 - Python bindings for GtkSourceView2.
   Copyright (C) 2009 - Gian Mario Tagliaretti <gianmt@gnome.org>
   
   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public License
   as published by the Free Software Foundation;
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU Lesser General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#ifndef _PYGTKSOURCEVIEW_PRIVATE_H_
#define _PYGTKSOURCEVIEW_PRIVATE_H_

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

typedef struct {
    PyObject *func, *data;
} PyGtkSourceViewCustomNotify;

void pygtksourceview_custom_destroy_notify(gpointer user_data);

#endif
