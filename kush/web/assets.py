# -*- coding: utf-8 -*-
# flake8: noqa
from __future__ import absolute_import

from flask.ext.assets import (
    Bundle,
)

from kush.base.assets import jquery, angular, bootstrap_js, bootstrap_css

web_scripts = Bundle('js/web/*.coffee', filters=('coffeescript'))
web_css = Bundle('css/web/*.less', filters=('recess',))

BUNDLES = [
    ('css-web', Bundle(bootstrap_css, web_css, filters=('cssmin',),output='kush.css')),
    ('js-web', Bundle(jquery, angular, bootstrap_js, web_scripts, filters=('jsmin',), output='kush.js')),
]
