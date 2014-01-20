#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# flake8: noqa

from __future__ import unicode_literals

from flask.ext.assets import (
    Bundle,
)

jquery = Bundle('vendor/jquery/jquery.js')
angular = Bundle('vendor/angular/angular.js')

bootstrap_js = Bundle(
    "vendor/uikit/src/js/core.js",
    "vendor/uikit/src/js/touch.js",
    "vendor/uikit/src/js/alert.js",
    "vendor/uikit/src/js/button.js",
    "vendor/uikit/src/js/dropdown.js",
    "vendor/uikit/src/js/grid.js",
    "vendor/uikit/src/js/modal.js",
    "vendor/uikit/src/js/offcanvas.js",
    "vendor/uikit/src/js/nav.js",
    "vendor/uikit/src/js/tooltip.js",
    "vendor/uikit/src/js/switcher.js",
    "vendor/uikit/src/js/tab.js",
    "vendor/uikit/src/js/search.js",
    "vendor/uikit/src/js/scrollspy.js",
    "vendor/uikit/src/js/smooth-scroll.js",
    "vendor/uikit/src/js/toggle.js",
)

bootstrap_css = Bundle(
    "vendor/bootstrap/less/bootstrap.less",
    "vendor/uikit/src/less/*.less",
    filters=('recess',),
)
