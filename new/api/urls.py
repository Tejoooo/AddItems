
from django.contrib import admin
from django.urls import path
from .views import *

urlpatterns = [
    path('',TodoListView.as_view()),
    path('detail/<int:pk>/',TodoDetail.as_view()),
    path('update/<int:pk>/',TodoDetailView.as_view()),
    path('user/',UserDetail.as_view()),
    path('userall/',AllUserDetail.as_view()),
    path('login/', LoginView.as_view()),
    path('signup/', SignupView.as_view(), name='signup'),
    path('user-todos/', UserTodoListView.as_view(), name='user-todo-list'),

]
