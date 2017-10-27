from django.http import HttpResponse
from django.shortcuts import render
from django.contrib.auth.decorators import user_passes_test

from subprocess import call

def index(request):
    return render(request, 'timer.html')

def user_is_judge(user):
    return user.groups.filter(name='judges').exists()

def get_args(post):
    if 'command' not in post:
        raise Error
    com = post['command']

    if com == 'no_game':
        return 'scripts/no_game.sh'
    elif com == 'end_game':
        return 'scripts/end_game.sh'
    elif com == 'set_flags_hidden':
        return ['scripts/set_flags.sh', '?']
    elif com == 'set_flags_number':
        red = post['red_flags']
        yellow = post['yellow_flags']
        return ['scripts/set_flags.sh', red + ' ' + yellow]
    else:
        raise Error

@user_passes_test(user_is_judge)
def judge(request):
    if request.method == 'POST':
        args = get_args(request.POST)
        call(args)
        return HttpResponse()
    else:
        return render(request, 'judge.html')

