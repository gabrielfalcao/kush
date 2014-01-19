#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright © 2013 Gabriel Falcão <gabriel@weedlabs.io>
#
from __future__ import unicode_literals, absolute_import

"""
kush.commands.db
~~~~~~~~~~~~~~~~~~~~~~

Contains commands for handling db stuff in the local environment
"""

import os
from flask.ext.script import Command



class CreateDB(Command):  # pragma: no cover
    def __init__(self, application):
        self.application = application

    def run(self):
        print "Creating database `kush`"
        os.system('echo "DROP DATABASE IF EXISTS kush" | mysql -uroot ')
        os.system('echo "CREATE DATABASE kush" | mysql -uroot ')
        print "Running migrations"
        os.system('alembic upgrade head')
