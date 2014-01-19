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
    "vendor/bootstrap/js/affix.js",
    "vendor/bootstrap/js/alert.js",
    "vendor/bootstrap/js/button.js",
    "vendor/bootstrap/js/carousel.js",
    "vendor/bootstrap/js/collapse.js",
    "vendor/bootstrap/js/dropdown.js",
    "vendor/bootstrap/js/modal.js",
    "vendor/bootstrap/js/popover.js",
    "vendor/bootstrap/js/scrollspy.js",
    "vendor/bootstrap/js/tab.js",
    "vendor/bootstrap/js/tooltip.js",
    "vendor/bootstrap/js/transition.js",
)

bootstrap_css = Bundle(
    "vendor/bootstrap/less/*.less",
    filters=('recess',),
)
