#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright © 2013 Gabriel Falcão <gabriel@weedlabs.io>
#
from __future__ import unicode_literals

import json
import socket
from kush import settings
from flask import Blueprint, render_template, session, url_for
from kush.framework.http import json_response
from kush.framework.handy.functions import get_ip
from twilio.rest import TwilioRestClient

module = Blueprint('web', __name__)


@module.context_processor
def inject_basics():
    return dict(
        settings=settings,
        messages=session.pop('messages', []),
        github_user=session.get('github_user_data', None),
        json=json,
        len=len,
        full_url_for=lambda *args, **kw: settings.absurl(
            url_for(*args, **kw)
        ),
        ssl_full_url_for=lambda *args, **kw: settings.sslabsurl(
            url_for(*args, **kw)
        ),
        static_url=lambda path: "{0}/{1}".format(
            settings.STATIC_BASE_URL.rstrip('/'),
            path.lstrip('/')
        ),
    )


@module.route('/')
def index():
    return render_template('index.html')


@module.route('/sms/<subdomain>')
def notify_sms(subdomain):
    remote_ip = get_ip()
    resolved_ip = socket.gethostbyname(subdomain)

    client = TwilioRestClient(
        settings.TWILIO_SID,
        settings.TWILIO_TOKEN)

    if remote_ip == resolved_ip:
        body = ("[weedlabs] Hi {name}, just a heads "
                "up that a new machine is available at {subdomain}")
    else:
        body = ("[weedlabs] Hi {name}, the ip {remote_ip} "
                "reported the domain {subdomain} but it rather "
                "resolves to the ip {resolved_ip}")

    for name, phone in settings.SMS_CONTACTS:
        message = client.sms.messages.create(
            body=body.format(**locals()),
            to=phone,
            from_=settings.TWILIO_PHONE)

    return json_response({
        'subdomain': subdomain,
        'resolved_ip': resolved_ip,
        'remote_ip': remote_ip,
    }, 200)
