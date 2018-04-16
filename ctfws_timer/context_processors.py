"""
Custom Django template context processors
These are registered in settings.py: TEMPLATES.OPTIONS.context_processors
"""

from ctfws_timer import settings

def debug_setting(request):
    """
    Add the DEBUG setting to the context in all cases (unlike the built-in
    debug context processor)
    """
    return {'DEBUG': settings.DEBUG}

def http_host(request):
    """
    Add the host from the HTTP request to the context without the port. The
    hostname with the port is available in context.get_host(), but there is no
    way to strip out the port while in a template.
    """
    return {'http_host': request.get_host().split(':')[0]}
