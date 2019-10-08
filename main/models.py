from django.db import models

class StuffCount(models.Model):
    red_flags = models.IntegerField(default=0, blank=True, null=True)
    yellow_flags = models.IntegerField(default=0, blank=True, null=True)

    red_hats = models.IntegerField(default=0, blank=True, null=True)
    yellow_hats = models.IntegerField(default=0, blank=True, null=True)

    red_jail = models.IntegerField(default=0, blank=True, null=True)
    yellow_jail = models.IntegerField(default=0, blank=True, null=True)
    red_yukko = models.IntegerField(default=0, blank=True, null=True)
    yellow_yukko = models.IntegerField(default=0, blank=True, null=True)
    red_alarm = models.IntegerField(default=0, blank=True, null=True)
    yellow_alarm = models.IntegerField(default=0, blank=True, null=True)
    red_gotcha = models.IntegerField(default=0, blank=True, null=True)
    yellow_gotcha = models.IntegerField(default=0, blank=True, null=True)
    red_recharge = models.IntegerField(default=0, blank=True, null=True)
    yellow_recharge = models.IntegerField(default=0, blank=True, null=True)

    red_wands = models.IntegerField(default=0, blank=True, null=True)
    green_wands = models.IntegerField(default=0, blank=True, null=True)
    blue_wands = models.IntegerField(default=0, blank=True, null=True)
    white_wands = models.IntegerField(default=0, blank=True, null=True)
    red_belts = models.IntegerField(default=0, blank=True, null=True)
    green_belts = models.IntegerField(default=0, blank=True, null=True)
    blue_belts = models.IntegerField(default=0, blank=True, null=True)
    white_belts = models.IntegerField(default=0, blank=True, null=True)
    red_potions = models.IntegerField(default=0, blank=True, null=True)
    green_potions = models.IntegerField(default=0, blank=True, null=True)
    blue_potions = models.IntegerField(default=0, blank=True, null=True)
    white_potions = models.IntegerField(default=0, blank=True, null=True)

class EventAssignments(models.Model):
    class Meta:
        verbose_name_plural = 'Event assignments'

    semester = models.CharField(max_length=255, unique=True,
        default='Unknown semester')

    def __str__(self):
        return str(self.semester)

class GameAssignments(models.Model):
    class Meta:
        verbose_name_plural = 'Game assignments'
        ordering = ['game_number']

    game_number = models.IntegerField(unique=True)

    event = models.ForeignKey(EventAssignments)

    head = models.CharField(max_length=255, blank=True, default='')

    dh_jail = models.CharField(max_length=255, blank=True, default='')
    dh_roam_1 = models.CharField(max_length=255, blank=True, default='')
    dh_roam_2 = models.CharField(max_length=255, blank=True, default='')

    weh_jail = models.CharField(max_length=255, blank=True, default='')
    weh_roam_1 = models.CharField(max_length=255, blank=True, default='')
    weh_roam_2 = models.CharField(max_length=255, blank=True, default='')

    on_call = models.CharField(max_length=255, blank=True, default='')
    playing = models.CharField(max_length=255, blank=True, default='')
    exec_people = models.CharField(max_length=255, blank=True, default='')

    def __str__(self):
        return '%s: Game %d' % (self.event, self.game_number)
