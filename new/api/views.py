from django.shortcuts import render
from .serializers import *
from .models import *
from rest_framework.permissions import IsAuthenticated
from rest_framework import generics
from django.contrib.auth import get_user_model, authenticate, login
from rest_framework.views import APIView
from rest_framework.response import Response

class TodoListView(generics.ListCreateAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer

class TodoDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer

class TodoDetailView(generics.RetrieveUpdateAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer

class UserDetail(generics.ListCreateAPIView):
    queryset = CustomeUser.objects.all()
    serializer_class = UserSerializer

class AllUserDetail(generics.ListCreateAPIView):
    queryset = get_user_model().objects.all()
    serializer_class = UserSerializer
UserModel = get_user_model()

class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        print(request.data)
        
        try:
            user = UserModel.objects.get(email=email)
        except UserModel.DoesNotExist:
            user = None
        
        if user is not None and user.check_password(password):
            authenticated_user = authenticate(request, username=user.username, password=password)
            if authenticated_user is not None:
                login(request, authenticated_user)
                return Response({'message': 'Login successful'})
        
        return Response({'message': 'Invalid email or password'}, status=401)

class SignupView(APIView):
    def post(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        password = request.data.get('password')
        confirm_password = request.data.get('confirm_password')
        print(username)
        print(request.data) 
        if password != confirm_password:
            return Response({'message': 'Passwords do not match'}, status=400)

        # Create a new user
        User = get_user_model()
        try:
            user = User.objects.create_user(username=username, email=email, password=password)
        except Exception as e:
            return Response({'message': str(e)}, status=400)

        # Login the user
        login(request, user)

        return Response({'message': 'Signup successful'})

class UserTodoListView(generics.ListAPIView):
    serializer_class = TodoSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Todo.objects.filter(user=user)