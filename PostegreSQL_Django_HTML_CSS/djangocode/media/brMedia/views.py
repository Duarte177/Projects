from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.template import loader
import json
import datetime


from .models import Person
from .models import Visualization
from .models import Review
from .models import Media
from .models import Film
from .models import Series
from .models import Genre
from .models import Director
from .models import Actor



def select_profile(request):
    template=loader.get_template('brMedia/select_user.html')
    people = Person.objects.all()
    context = {
        'users':people,
    }
    return HttpResponse(template.render(context, request))





def user_profile(request):
    user_id = request.GET.get('user')  
    user = Person.objects.get(id=user_id)
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()
    
    context = {
        'userID': user_id,
        'user_name':user.name,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors, 
    }
    template=loader.get_template('brMedia/homepage.html')
    return HttpResponse(template.render(context, request))




def search(request):
    user_id = request.GET.get('user')
    user = Person.objects.get(id=user_id)
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()

    query = request.GET.get('query')
    user_words = query.split()

    all_media = Media.objects.all()
    actual_media = []

    for media in all_media:
        for word in user_words:
            if word.lower() in media.title.lower():

                reviews = Review.objects.filter(media_id=media.id)
                data_reviews = [
                        {
                            'review_date': str(review.rev_date),
                            'rating': review.rating,
                            'comment': review.comment,
                            'reviewer': Person.objects.get(id=review.person_id).name,
                        }
                        for review in reviews
                    ]
                json_data_reviews = json.dumps(data_reviews)

                if media.media_type == 'Film':
                    film = Film.objects.select_related('media_ptr').prefetch_related('actors', 'directors', 'genre').all().get(media_ptr_id = media.id)
                    
                    actual_media.append({
                        'type': 'film',
                        'title': media.title,
                        'release_date': media.release_date,
                        'duration': film.duration,
                        'actors': ", ".join(actor.name for actor in film.actors.all()),
                        'directors': ", ".join(director.name for director in film.directors.all()),
                        'genres': ", ".join(genre.name for genre in film.genre.all()),
                        'synopsis': film.synopsis,
                        'reviews': json_data_reviews,
                    })

                elif media.media_type == 'Serie':
                    serie = Series.objects.select_related('media_ptr').prefetch_related('actors', 'directors', 'genre').all().get(media_ptr_id = media.id)
                    actual_media.append({
                        'type': 'serie',
                        'title': media.title,
                        'release_date': media.release_date,
                        'episodes': serie.episodes,
                        'seasons': serie.seasons,
                        'actors': ", ".join(actor.name for actor in serie.actors.all()),
                        'directors': ", ".join(director.name for director in serie.directors.all()),
                        'genres': ", ".join(genre.name for genre in serie.genre.all()),
                        'synopsis': serie.synopsis,
                        'reviews': json_data_reviews,
                    })


    context = {
        'userID': user_id,
        'user_name':user.name,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
        'all_media': actual_media,
    }
    template=loader.get_template('brMedia/search.html')
    return HttpResponse(template.render(context, request))






def films(request):
    user_id = request.GET.get('user')  
    user = Person.objects.get(id=user_id)
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()
    
    
    # Filtra apenas os filmes (fazendo o join com a tabela de Media) e as suas respetivas relações many-to-many
    all_films = Film.objects.select_related('media_ptr').prefetch_related('actors', 'directors', 'genre').all()
    
    films_data = []
    for film in all_films:

        # Recolher as reviews associadas ao filme
        reviews = Review.objects.filter(media_id=film.media_ptr.id)
        data_reviews = [
                {
                    'review_date': str(review.rev_date),
                    'rating': review.rating,
                    'comment': review.comment,
                    'reviewer': Person.objects.get(id=review.person_id).name,
                }
                for review in reviews
            ]
        json_data_reviews = json.dumps(data_reviews)


        films_data.append({
            'title': film.media_ptr.title,
            'release_date': film.media_ptr.release_date,
            'duration': film.duration,
            'actors': ", ".join(actor.name for actor in film.actors.all()),
            'directors': ", ".join(director.name for director in film.directors.all()),
            'genres': ", ".join(genre.name for genre in film.genre.all()),
            'synopsis': film.synopsis,
            'reviews': json_data_reviews,
        })

    context = {
        'userID': user_id,
        'user_name':user.name,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
        'all_films': films_data,
        'type_media': 'film',
    }
    template=loader.get_template('brMedia/media.html')
    return HttpResponse(template.render(context, request))







def series(request):
    user_id = request.GET.get('user')  
    user = Person.objects.get(id=user_id)
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()
    
    all_series = Series.objects.select_related('media_ptr').prefetch_related('actors','directors','genre').all()


    series_data = []
    for serie in all_series:

        # Recolher as reviews associadas a serie
        reviews = Review.objects.filter(media_id=serie.media_ptr.id)
        data_reviews = [
                {
                    'review_date': str(review.rev_date),
                    'rating': review.rating,
                    'comment': review.comment,
                    'reviewer': Person.objects.get(id=review.person_id).name,
                }
                for review in reviews
            ]
        json_data_reviews = json.dumps(data_reviews)


        series_data.append({
            'title': serie.media_ptr.title,
            'release_date': serie.media_ptr.release_date,
            'episodes': serie.episodes,
            'seasons': serie.seasons,
            'actors': ", ".join(actor.name for actor in serie.actors.all()),
            'directors': ", ".join(director.name for director in serie.directors.all()),
            'genres': ", ".join(genre.name for genre in serie.genre.all()),
            'synopsis': serie.synopsis,
            'reviews': json_data_reviews ,
        })


    context = {
        'userID': user_id,
        'user_name':user.name,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
        'all_series': series_data,
        'type_media': 'serie',
    }
    template=loader.get_template('brMedia/media.html')
    return HttpResponse(template.render(context, request))





def reviews(request):
    user_id = request.GET.get('user')  
    user = Person.objects.get(id=user_id)
    all_genre = Genre.objects.all()
    all_media = Media.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()

    all_reviews = Review.objects.all()

    review_boolean = False
    data_reviews = []
    for review in all_reviews:
        if review.person_id == int(user_id):
            review_boolean = True
            actual_media = Media.objects.get(id=review.media_id)
            title = actual_media.title

            data_reviews.append({
                'title': title,
                'review_date': str(review.rev_date),
                'rating': review.rating,
                'comment': review.comment,
                'reviewer': Person.objects.get(id=review.person_id).name,
            })
 
    context = {
        'userID': user_id,
        'user_name':user.name,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
        'all_media': data_reviews,
        'review_boolean': review_boolean
    }
    template=loader.get_template('brMedia/reviews.html')
    return HttpResponse(template.render(context, request))





def submit_review(request):
    
    user_id = request.GET.get('id')  
    user = Person.objects.get(id=user_id)

    comment = request.GET.get('comment')
    rating = request.GET.get('rating')
    title1 = request.GET.get('media_title')  

    try:
        media = Media.objects.get(title=title1)
    except Media.DoesNotExist:
        return HttpResponse("Media not found", status=404)

    # Salvar no postgres
    review = Review(
        rev_date=datetime.date.today(),
        rating=int(rating),
        comment=comment,
        media_id=media.id,
        person_id=user_id
    )
    review.save()

    print('message:Review successfully saved')
    return redirect(request.META.get('HTTP_REFERER'))
    






def visualization(request):
    user_id = request.GET.get('user')
    user = Person.objects.get(id=user_id)
    visualizations = Visualization.objects.filter(person=user).order_by('-view_date')
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()

    context = {
        'userID': user_id,
        'user_name': user.name,
        'visualizations': visualizations,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,

    }
    template = loader.get_template('brMedia/visualization.html')
    return HttpResponse(template.render(context, request))



def genres(request, genre_name):
    user_id = request.GET.get('user')
    genre = Genre.objects.get(name=genre_name) 
    user = Person.objects.get(id=user_id)
    media= genre.media_genre.all()
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()
    context = {
        'genre': genre,
        'user_name':user.name,
        'userID':user_id,
        'media': media,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
    }

    template = loader.get_template('brMedia/genres.html')
    return HttpResponse(template.render(context, request))






def actors(request, actor_name):
    user_id = request.GET.get('user')  
    actor=Actor.objects.get(name=actor_name)
    user = Person.objects.get(id=user_id)
    media = actor.media_actor.all()
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()

    context = {
        'userID': user_id,
        'user_name':user.name,
        'actor': actor,
        'media': media,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
    }
    template=loader.get_template('brMedia/actors.html')
    return HttpResponse(template.render(context, request))




def directors(request, director_name):
    user_id = request.GET.get('user') 
    director=Director.objects.get(name=director_name) 
    user = Person.objects.get(id=user_id)
    media = Media.objects.all()
    all_genre = Genre.objects.all()
    all_actors = Actor.objects.all()
    all_directors = Director.objects.all()

    context = {
        'userID': user_id,
        'user_name':user.name,
        'director': director,
        'media':media,
        'all_genre': all_genre,
        'all_actors': all_actors,
        'all_directors': all_directors,
    }
    template=loader.get_template('brMedia/directors.html')
    return HttpResponse(template.render(context, request))