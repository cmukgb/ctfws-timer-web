from django.http import HttpResponse
from django.shortcuts import render
from django.contrib.auth.decorators import user_passes_test
from django.forms import modelform_factory

from subprocess import call

from .models import StuffCount

StuffCountForm = modelform_factory(StuffCount, fields='__all__')

def index(request):
    return render(request, 'timer.html')

def user_is_judge(user):
    return user.groups.filter(name='judges').exists()

def get_args(post):
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
        return HttpResponse('Unknown command', status=500)

@user_passes_test(user_is_judge)
def judge(request):
    if request.method == 'POST':
        if 'command' not in request.POST:
            return HttpResponse('No command specified', status=500)
        elif request.POST['command'] == 'save_count_totals':
            query = StuffCount.objects.all()
            if query.count() > 0:
                totals = query[0]
            else:
                totals = StuffCount()
            form = StuffCountForm(request.POST, instance=totals)
            if form.is_valid():
                form.save()
            else:
                return HttpResponse('Invalid data', status=500)
        else:
            args = get_args(request.POST)
            call(args)
        return HttpResponse()

    else:
        query = StuffCount.objects.all()
        if query.count() > 0:
            totals = query[0]
        else:
            totals = StuffCount() # Defaults all fields to 0
        form = StuffCountForm()
        return render(request, 'judge.html', {'totals': totals, 'form': form})

