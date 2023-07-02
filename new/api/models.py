from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.contrib.auth.models import User


# Create your models here.
class Todo(models.Model):
    user = models.ForeignKey(User,on_delete=models.CASCADE,related_name='todos', default=1)
    title = models.CharField(max_length=20)
    description = models.CharField(max_length=20)

    def __str__(self):
        return self.title
    
class CustomeUser(AbstractUser):
    groups = models.ManyToManyField(Group, related_name='custom_users')
    user_permissions = models.ManyToManyField(Permission, related_name='custom_users')

    def __str__(self):
        return self.username