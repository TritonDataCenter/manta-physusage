#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2015, Joyent, Inc.
#

#
# This Makefile contains only repo-specific logic and uses included makefiles to
# supply common targets (javascriptlint, jsstyle, restdown, etc.), which are
# used by other repos as well.  If you find yourself adding support for new
# targets that could be useful for other projects too, you should add these to
# the original versions of the included Makefiles (in eng.git) so that other
# teams can use them too.
#

#
# Tools
#
BASHSTYLE	 = ./tools/bashstyle

#
# Files
#
BASH_FILES	 = manta-cn-physusage
JS_FILES	 = manta-physusage-summary
JSL_CONF_NODE	 = tools/jsl.node.conf
JSL_FILES_NODE	 = $(JS_FILES)
JSSTYLE_FILES	 = $(JS_FILES)

check::

include tools/Makefile.targ
