from django.http import HttpResponse
from django.shortcuts import render
from django.contrib.auth.decorators import user_passes_test
from django.forms import modelform_factory

import os
import subprocess

from ctfws_timer import settings
from .models import StuffCount

StuffCountForm = modelform_factory(StuffCount, fields='__all__')

def index(request):
    return render(request, 'timer.html')

def user_is_judge(user):
    return user.groups.filter(name='judges').exists()

def get_args(post):

    base_dir = settings.BASE_DIR
    no_game = os.path.join(base_dir, 'scripts', 'no_game.sh')
    start_game = os.path.join(base_dir, 'scripts', 'start_game.sh')
    end_game = os.path.join(base_dir, 'scripts', 'end_game.sh')
    set_flags = os.path.join(base_dir, 'scripts', 'set_flags.sh')
    send_message = os.path.join(base_dir, 'scripts', 'send_message.sh')
    send_player_message = os.path.join(base_dir, 'scripts', 'send_player_message.sh')
    send_jail_message = os.path.join(base_dir, 'scripts', 'send_jail_message.sh')
    clear_messages = os.path.join(base_dir, 'scripts', 'clear_messages.sh')

    com = post['command']
    if com == 'no_game':
        return [no_game]
    elif com == 'end_game':
        result = [end_game]
        if 'hide_flags' in post and post['hide_flags'] == 'on':
            result += ['--hide-flags']
        if 'end_timestamp' in post and post['end_timestamp'] != '':
            result += [post['end_timestamp']]
        return result
    elif com == 'set_flags_hidden':
        return [set_flags, '?']
    elif com == 'set_flags_number':
        red = post['red_flags']
        yellow = post['yellow_flags']
        return [set_flags, red + ' ' + yellow]
    elif com == 'send_message':
        if post['message_type'] == 'both':
            result = [send_message]
        elif post['message_type'] == 'player':
            result = [send_player_message]
        elif post['message_type'] == 'jail':
            result = [send_jail_message]
        else:
            return None
        result += [post['message']]
        if 'message_timestamp' in post and post['message_timestamp'] != '':
            result += [post['message_timestamp']]
        return result
    elif com == 'start_game':
        result = [start_game, post['num_flags'], post['game_num'],
                post['territory']]
        if 'start_timestamp' in post and post['start_timestamp'] != '':
            result += [post['start_timestamp']]
        if 'zero_flags' in post and post['zero_flags'] == 'on':
            result += ['--zero-flags']
        return result
    elif com == 'clear_messages':
        result = [clear_messages]
        if 'clear_timestamp' in post and post['clear_timestamp'] != '':
            result += [post['clear_timestamp']]
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
                return HttpResponse()
            else:
                return HttpResponse('Invalid data', status=500)
        else:
            args = get_args(request.POST)
            if args is None:
                return HttpResponse('Unknown command', status=500)
            try:
                output = subprocess.check_output(args, stderr=subprocess.STDOUT)
                return HttpResponse(output)
            except subprocess.CalledProcessError as err:
                return HttpResponse(err.output, status=500)
    else:
        query = StuffCount.objects.all()
        if query.count() > 0:
            totals = query[0]
        else:
            totals = StuffCount() # Defaults all fields to 0
        form = StuffCountForm()
        return render(request, 'judge.html', {'totals': totals, 'form': form})
