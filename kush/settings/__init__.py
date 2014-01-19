# -*- coding: utf-8; mode: python -*-
from milieu import Environment
import os
import sys

env = Environment()

SELF = sys.modules[__name__]

from os.path import join, abspath


os.environ.setdefault('REDIS_URI', 'redis://localhost:6379')
os.environ.setdefault('DOMAIN', 'kush.weedlabs.io')
os.environ.setdefault('HOST', 'kush.weedlabs.io')


##########
# 3rd party stuff

GOOGLE_ANALYTICS_CODE = 'UA-46592615-1'
##########

TWILIO_SID = 'ACb3f027374dc9789c0e89f162850b3715'
TWILIO_TOKEN = '5110beb37b3871593d41f5f0dba098f4'

LOCAL_PORT = 8000
PORT = env.get_int('PORT', LOCAL_PORT)

#STATIC_BASE_URL = '//static.kush.s3-website-us-east-1.amazonaws.com/s/'
STATIC_BASE_URL = '/static/'

# Identifying environment
LOCAL = env.get('KUSH_LOCAL_MODE') or (PORT is LOCAL_PORT)
SQLALCHEMY_DATABASE_URI = env.get('SQLALCHEMY_DATABASE_URI')

# setting up environment variables after all
if LOCAL:
    print "using custom localhost-specific settings"
    from .local import setup_localhost
    setup_localhost(SELF)

# Detecting environment
PRODUCTION = not LOCAL
DEBUG = not PRODUCTION
TESTING = env.get_bool('TESTING', False)
UNIT_TESTING = env.get_bool('UNIT_TESTING', False)

# HTTP
HOST = env.get("HOST")
DOMAIN = env.get("DOMAIN")
SCHEME = PORT == 443 and 'https://' or "http://"

# Database-related
REDIS_URI = env.get_uri("REDIS_URI")


# Filesystem
LOCAL_FILE = lambda *path: abspath(join(__file__, '..', '..', *path))

# Security
SECRET_KEY = env.get("SESSION_SECRET_KEY")

# Logging
LOGGER_NAMES = [
    'kush',
    'kush.api.models',
    'kush.api.resources',
    'kush.framework.http',
    'kush.framework.db',
    'kush.web.models',
    'kush.web.controllers',
]

SALT = 'SGP#n>*3XJ)E9oubtmf"? bK'
GEO_IP_FILE_LOCATION = LOCAL_FILE('data', 'GeoIPCity.dat')
absurl = lambda *path: "{0}{1}/{2}".format(
    SCHEME, DOMAIN, "/".join(path).lstrip('/'))

sslabsurl = lambda *path: "{0}{1}/{2}".format(
    "https://", DOMAIN, "/".join(path).lstrip('/'))

kush_path = abspath(join(__file__, '..', '..'))

SMS_CONTACTS = [
    ("Gabriel", "+13479872711"),
    ("Lincoln", "+16464790147"),
]
TWILIO_PHONE = '+13475156758'
