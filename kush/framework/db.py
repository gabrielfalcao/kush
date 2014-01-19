#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright © 2013 Gabriel Falcão <gabriel@weedlabs.io>
#
from __future__ import unicode_literals

from redis import StrictRedis
from kush import settings


def get_redis_connection(db=0):
    """This function knows how to return a new `redis.StrictRedis`
    instance with the redis credentials from settings"""
    conf = settings.REDIS_URI

    return StrictRedis(
        db=db,
        host=conf.host,
        port=conf.port,

        # using `path` as password to support the URI like:
        # redis://hostname:port/veryverylongpasswordhashireallymeanSHA512
        password=conf.path,
    )
