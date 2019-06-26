from django.contrib import admin

from .models import StuffCount, EventAssignments, GameAssignments

admin.site.register(StuffCount)
admin.site.register(EventAssignments)
admin.site.register(GameAssignments)
