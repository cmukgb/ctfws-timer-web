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
