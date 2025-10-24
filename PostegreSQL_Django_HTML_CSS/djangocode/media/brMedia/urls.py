from django.urls import path

from . import views

urlpatterns = [
    path('films/',views.films, name='films'),
    path('series/',views.series,name='series'),
    path('genres/<str:genre_name>/', views.genres, name='genres'),
    path('directors/<str:director_name>/', views.directors, name='directors'),
    path('actors/<str:actor_name>/', views.actors, name='actors'),
    path('profile/',views.select_profile, name='select_profile'),
    path('user_profile/', views.user_profile, name='user_profile'),
    path('visualization',views.visualization, name='visualization'),
    path('reviews',views.reviews,name='reviews'),
    path('submit-review', views.submit_review, name='submit_review'),
    path('search', views.search,name='search')
]