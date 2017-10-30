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
        return ['scripts/no_game.sh']
    elif com == 'end_game':
        result = ['scripts/end_game.sh']
        if 'hide_flags' in post and post['hide_flags'] == 'on':
            result += ['--hide-flags']
        if 'end_timestamp' in post and post['end_timestamp'] != '':
            result += [post['end_timestamp']]
        return result
    elif com == 'set_flags_hidden':
        return ['scripts/set_flags.sh', '?']
    elif com == 'set_flags_number':
        red = post['red_flags']
        yellow = post['yellow_flags']
        return ['scripts/set_flags.sh', red + ' ' + yellow]
    elif com == 'send_message':
        if post['message_type'] == 'both':
            result = ['scripts/send_message.sh']
        elif post['message_type'] == 'players':
            result = ['scripts/send_player_message.sh']
        elif post['message_type'] == 'jail':
            result = ['scripts/send_jail_message.sh']
        else:
            return None
        result += [post['message']]
        if 'message_timestamp' in post and post['message_timestamp'] != '':
            result += [post['message_timestamp']]
        return result
    elif com == 'start_game':
        result = ['scripts/start_game.sh', post['num_flags'], post['game_num']]
        if 'start_timestamp' in post and post['start_timestamp'] != '':
            result += [post['start_timestamp']]
        return result
    else:
        return None

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
            if args is None:
                return HttpResponse('Unknown command', status=500)
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

