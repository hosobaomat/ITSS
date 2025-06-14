# import bcrypt
# from django.shortcuts import render, redirect
# from django.contrib import messages
# from .models import Users

# def user_login(request):
#     if request.method == 'POST':
#         email = request.POST.get('email')
#         password = request.POST.get('password')
#         try:
#             user = Users.objects.get(email=email)
#             # Kiểm tra password nhập vào với hash trong DB
#             if bcrypt.checkpw(password.encode(), user.password.encode()) and user.role == 'admin':
#                 request.session['user_id'] = user.user_id
#                 request.session['username'] = user.username
#                 request.session['role'] = user.role
#                 return redirect('/admin/')
#             else:
#                 messages.error(request, 'Sai mật khẩu hoặc bạn không phải admin!')
#         except Users.DoesNotExist:
#             messages.error(request, 'Không tìm thấy email này!')
#     return render(request, 'login.html')


# def user_logout(request):
#     request.session.flush()
#     return redirect('/login/')
