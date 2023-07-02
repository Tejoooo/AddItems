from rest_framework import serializers
from .models import *
from django.contrib.auth.models import AbstractUser

class TodoSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Todo
        fields =  '__all__' 

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomeUser
        fields = ['id','email','username',]