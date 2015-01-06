#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# flake8: noqa

from __future__ import unicode_literals

from flask.ext.assets import (
    Bundle,
)

jquery = Bundle('vendor/jquery/dist/jquery.js')
angular = Bundle('vendor/angular/angular.js')

bootstrap_js = Bundle(
    "vendor/uikit/js/core/core.js",
    "vendor/uikit/js/core/touch.js",
    "vendor/uikit/js/core/alert.js",
    "vendor/uikit/js/core/button.js",
    "vendor/uikit/js/core/dropdown.js",
    "vendor/uikit/js/core/grid.js",
    "vendor/uikit/js/core/modal.js",
    "vendor/uikit/js/core/offcanvas.js",
    "vendor/uikit/js/core/nav.js",
    "vendor/uikit/js/core/tooltip.js",
    "vendor/uikit/js/core/switcher.js",
    "vendor/uikit/js/core/tab.js",
    "vendor/uikit/js/components/search.js",
    "vendor/uikit/js/core/scrollspy.js",
    "vendor/uikit/js/core/smooth-scroll.js",
    "vendor/uikit/js/core/toggle.js",
)

bootstrap_css = Bundle(
    "vendor/bootstrap/less/bootstrap.less",
    "vendor/uikit/src/less/*.less",
    filters=('recess',),
)
