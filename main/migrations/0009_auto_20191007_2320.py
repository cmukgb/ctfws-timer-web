# -*- coding: utf-8 -*-
# Generated by Django 1.11.25 on 2019-10-08 03:20
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0008_auto_20190626_0253'),
    ]

    operations = [
        migrations.RenameField(
            model_name='gameassignments',
            old_name='exec',
            new_name='exe',
        ),
    ]
